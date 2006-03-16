# -*- cperl -*-
# $Author: ddumont $
# $Date: 2006/02/23 13:43:31 $
# $Name:  $
# $Revision: 1.3 $

use warnings FATAL => qw(all);

use ExtUtils::testlib;
use Test::More tests => 32 ;
use Config::Model ;

use strict;

my $arg = shift || '';

my $trace = $arg =~ /t/ ? 1 : 0 ;
$::verbose          = 1 if $arg =~ /v/;
$::debug            = 1 if $arg =~ /d/;
Config::Model::Exception::Any->Trace(1) if $arg =~ /e/;

ok(1,"Compilation done");

# minimal set up to get things working
my $model = Config::Model->new() ;
$model ->create_config_class 
  (
   name => 'SlaveY',
   element =>
   [
    [qw/X Y/] => { 
		  type => 'leaf',
		  value_type => 'enum',
		  choice     => [qw/Av Bv Cv/],
		  warp       => {
				 follow => '- - v_macro',
				 rules => { A => { default => 'Av' },
					    B => { default => 'Bv' }
					  }
				}
		 }
   ]
  );

$model ->create_config_class 
  (
   name => 'SlaveZ',
   element =>
   [
    [qw/X Z/] => { 
		  type => 'leaf',
		  value_type => 'enum',
		  choice     => [qw/Av Bv Cv/],
		  warp       => {
				 follow => '! v_macro',
				 rules => { A => { default => 'Av' },
					    B => { default => 'Bv' }
					  }
				}
		 }
   ]
  );

$model ->create_config_class 
  (
   name => 'Master',
   permission => [ bar => 'advanced'] ,
   element =>
   [
    v_macro => { 
		type => 'leaf',
		value_type => 'enum',
		choice     => [qw/A B/]
	       },
    b_macro    => {type => 'leaf',value_type => 'boolean' },
    tree_macro => {type => 'leaf',
		   value_type => 'enum',
		   choice     => [qw/XY XZ mXY W AR/]
		  },

    'a_hash_of_warped_nodes'
    => {
	type => 'hash',
	index_type  => 'string',
	collected_type => 'node',
	warp  =>  { follow => '! tree_macro',
		    morph   => 1,
		    rules => { XY  => { config_class_name => 'SlaveY', },
			       mXY => {
				       config_class_name   => 'SlaveY',
				       permission => 'intermediate'
				      },
			       XZ => { config_class_name => 'SlaveZ' }
			     }
		  }
       },
    'a_warped_node'
    => {
	type => 'warped_node',
	follow  => '! tree_macro',
	morph   => 1,
	rules => {
		  XY  => { config_class_name => ['SlaveY'], },
		  mXY => {
			  config_class_name   => 'SlaveY',
			  permission => 'intermediate'
			 },
		  XZ => { config_class_name => 'SlaveZ' }
		 }
       },
    bool_object => {
		    type => 'warped_node',
		    follow  => '! b_macro',
		    rules => { 1 => { config_class_name => 'SlaveY' }, }
		   },
   ]
  );

ok(1,"compiled");

my $inst = $model->instance (root_class_name => 'Master', 
				 instance_name => 'test1');
ok($inst,"created dummy instance") ;

my $root = $inst -> config_root ;

is($root->is_element_available('a_hash_of_warped_nodes'),0,
   'check that a_hash_of_warped_nodes is not available'
  ) ;

eval { $root->fetch_element('a_hash_of_warped_nodes')->fetch_with_id(1) 
	 -> fetch_element('X')->store('coucou');} ;
ok($@,'test stored on a warped node element (should fail)') ;
print "Normal error:\n", $@ if $trace ;

is($root->fetch_element('tree_macro')->store('XY'),'XY',
   'set master->tree_macro to XY');

my $ahown = $root->fetch_element('a_hash_of_warped_nodes') ;
is( $ahown->fetch_with_id(234) -> config_class_name, 'SlaveY' ,
   "reading a_hash_of_warped_nodes (is SlaveY because tree_macro was set)") ;

is($root->fetch_element('tree_macro')->store('XZ'),'XZ',
   'set master->tree_macro to XZ');

is( $ahown->fetch_with_id(234) -> config_class_name, 'SlaveZ' ,
   "reading a_hash_of_warped_nodes (is SlaveZ because tree_macro was set)") ;

is($ahown->fetch_with_id(234) -> fetch_element('X')->fetch, undef,  
   'reading master a_hash_of_warped_nodes:234 X (undef)');

is($root->fetch_element('v_macro')->store('A'),'A',
   'set master v_macro to A');

map {
    is($ahown->fetch_with_id(234) -> fetch_element($_)->fetch, 'Av',  
       "reading master a_hash_of_warped_nodes:234 $_ (default value)");
    } qw/X Z/ ;

map {
    is($ahown->fetch_with_id(234) -> fetch_element($_)->store('Cv'), 'Cv',  
       "Set master a_hash_of_warped_nodes:234 $_ to Cv");
    } qw/X Z/ ;

is($root->fetch_element('tree_macro')->store('mXY'),'mXY',
   'set master->tree_macro to mXY (with morphing)...');

is($ahown->fetch_with_id(234) -> fetch_element('X')->fetch, 'Cv',  
       "... X value was kept ...");

is($ahown->fetch_with_id(234) -> fetch_element('Y')->fetch, 'Av',  
       "... Y is back to default value");

is($root->fetch_element('v_macro')->store('B'),'B',
   'set master v_macro to B');

is($ahown->fetch_with_id(234) -> fetch_element('X')->fetch, 'Cv',  
       "... X value was kept ...");

is($ahown->fetch_with_id(234) -> fetch_element('Y')->fetch, 'Bv',  
       "... Y is to new default value");

# TBD 
#print "Testing dump on warped object\n" if $trace;
#my $dump = cute_dump( object => $master );
#ok( $dump, qr/ X = Cv/ );


my $warped_node = $root -> fetch_element( 'a_warped_node') ;
isa_ok($warped_node,"Config::Model::WarpedNode", "created warped node") ;

is($ahown->fetch_with_id(234)->element_name, 'a_hash_of_warped_nodes', 
  'Check element name of warped node') ;
is($ahown->fetch_with_id(234)->index_value, '234', 
  'Check index value of warped node') ;

# should also check that info was passed to actual node below (data
# element)
is($ahown->fetch_with_id(234)->element_name, 'a_hash_of_warped_nodes', 
   'Check element name of actual node below warped node') ;
is($ahown->fetch_with_id(234)->index_value, '234', 
   'Check index value of actual node below warped node') ;

is_deeply([$root->get_element_name(for => 'intermediate')],
	  [qw/v_macro b_macro tree_macro a_hash_of_warped_nodes 
              a_warped_node/],
	 'reading elements of root') ;

is($root->fetch_element('tree_macro')->store('W'),'W',
   'set master->tree_macro to W (warp out)...');

is_deeply([$root->get_element_name(for => 'intermediate')],
	  [qw/v_macro b_macro tree_macro/],
	 'reading elements of root after warp out') ;

is_deeply([$root->get_element_name(for => 'advanced')],
	  [qw/v_macro b_macro tree_macro/],
	 'reading elements of root after warp out') ;


is($root->fetch_element('b_macro')->store(1),1,
   'set master->b_macro to 1 (warp in bool_object)...');

$root->fetch_element('b_macro')->store(1) ;

is($root->fetch_element('bool_object')->config_class_name,
   'SlaveY',
   'check theorical bool_object type...');

