# -*- cperl -*-
# $Author: ddumont $
# $Date: 2006/02/16 13:09:43 $
# $Name:  $
# $Revision: 1.2 $

use warnings FATAL => qw(all);

use ExtUtils::testlib;
use Test::More tests => 21 ;
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
   'element' => [ 
		 [qw/X Y/] => { type => 'leaf',
				value_type => 'enum',
				choice     => [qw/Av Bv Cv/]
			      }
		]
  );

$model ->create_config_class 
  (
   name => 'SlaveZ',
   element => [
	       [qw/X Z/] => { type => 'leaf',
			      value_type => 'enum',
			      choice     => [qw/Av Bv Cv/]
			    }
	      ]
  );

$model ->create_config_class 
  (
   name => 'Master',
   permission => [ bar => 'advanced' ],
   #level => [bar => 'hidden'],
   'element'
   => [
       macro1 => { type => 'leaf',
		   value_type => 'enum',
		   choice     => [qw/A B/]
		 },
       macro2 => { type => 'leaf',
		   value_type => 'enum',
		   choice     => [qw/C D/]
		 },
       'bar'
       => { type => 'hash',
	    index_type => 'string',
	    collected_type => 'node',
	    'warp'
	    => { follow => [ '! macro1', '- macro2' ],
		 morph  => 1,
		 'rules'
		 => [
		     [qw/A C/] => {'config_class_name' => 'SlaveY'},
		     [qw/A D/] => {'config_class_name' => 'SlaveY',
				   permission => 'intermediate'
				  },
		     [qw/B C/] => {'config_class_name' => 'SlaveZ'},
		     [qw/B D/] => {'config_class_name' => 'SlaveZ'},
		    ]
	       }
	  }
      ]
   );


my $inst = $model->instance (root_class_name => 'Master', 
			     instance_name => 'test1');
ok($inst,"created dummy instance") ;

my $root = $inst -> config_root ;

ok( $root, "Created Root" );

is( $root-> is_element_available(name => 'bar'), 0,
  'check element bar for intermediate user (not available because macro* are undef)') ;
is( $root-> is_element_available(name => 'bar', permission => 'advanced'), 0,
  'check element bar for advanced user (not available because macro* are undef)') ;

ok( $root->load('macro1=A'), 'set macro1 to A'  );

is( $root-> is_element_available(name => 'bar'), 0,
  'check element bar for intermediate user (not available because macro2 is undef)') ;
is( $root-> is_element_available(name => 'bar', permission => 'advanced'), 0,
  'check element bar for advanced user (not available because macro2 is undef)') ;

eval {$root->load('bar:1 X=Av')} ;
ok($@,"writing to slave->bar (fails tree_macro is undef)") ;
print "normal error:\n", $@, "\n" if $trace;

ok( $root->load('macro2=C'), 'set macro2 to C'  );

is( $root-> is_element_available(name => 'bar'), 0,
  'check element bar for intermediate user (not available)') ;

is( $root-> is_element_available(name => 'bar', permission => 'advanced'), 1,
  'check element bar for advanced user (now available)') ;

$root->load(step => 'bar:1 X=Av', permission => 'master') ;

is ($root->grab('bar:1')->config_class_name ,'SlaveY',
   'check bar:1 config class name') ;

is($root->get_element_property(element =>'bar', property => 'permission'),
   'advanced', 'check bar permission') ;

ok( $root->load('macro2=D'), 'set macro2 to D'  );

is ($root->grab('bar:1')->config_class_name ,'SlaveY',
   'check bar:1 config class name (is SlaveZ)') ;

is($root->get_element_property(element =>'bar', property => 'permission'),
   'intermediate', 'check bar permission') ;

ok( $root->load('macro1=B'), 'set macro1 to B'  );

is ($root->grab('bar:1')->config_class_name ,'SlaveZ',
   'check bar:1 config class name (is now SlaveZ)') ;

is( $root-> is_element_available(name => 'bar', permission => 'advanced'), 1,
  'check element bar permission (back to advanced )') ;

my @array = $root->fetch_element('bar')-> get_all_warper_object ;
is( @array, 2, "test number of warper for bar elements" );