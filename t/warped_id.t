# -*- cperl -*-
# $Author: ddumont $
# $Date: 2006/02/23 13:43:30 $
# $Name:  $
# $Revision: 1.3 $

use warnings FATAL => qw(all);

use ExtUtils::testlib;
use Test::More tests => 30 ;
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
   name => 'Slave',
   element => [
	       [qw/X Y Z/] => { type => 'leaf',
				value_type => 'enum',
				choice     => [qw/Av Bv Cv/],
			      }
	      ]
   );

$model ->create_config_class 
  (
   name => 'Master',
   'element'
   => [
       macro => { type => 'leaf',
		  value_type => 'enum',
		  name       => 'macro',
		  choice     => [qw/A B C/],
		},
       version => { type => 'leaf',
		    value_type => 'integer',
		    default    => 1
		  },
       warped_hash => { type => 'hash',
			index_type => 'integer',
			max_nb     => 3,
			warp       => {
				       follow => '- macro',
				       rules => { A => { max_nb => 1 },
						  B => { max_nb => 2 }
						}
				      },
			collected_type => 'node',
			config_class_name => 'Slave'
		      },
       'multi_warp' 
       => { type => 'hash',
	    index_type => 'integer',
	    min        => 0,
	    max        => 3,
	    default    => [ 0 .. 3 ],
	    warp
	    => {
		follow => [ '- version', '- macro' ],
		'rules'
		=> [ [ '2', 'C' ] => { max => 7, default => [ 0 .. 7 ] },
		     [ '2', 'A' ] => { max => 7, default => [ 0 .. 7 ] }
		   ]
	       },
	    collected_type => 'node',
	    config_class_name => 'Slave'
	  },
       'multi_auto_create'
       => { type => 'hash',
	    index_type  => 'integer',
	    min         => 0,
	    max         => 3,
	    auto_create => [ 0 .. 3 ],
	    'warp'
	    => { follow => [ '- version', '- macro' ],
		'rules'
		 => [ [ '2', 'C' ] => { max => 7, auto_create => [ 0 .. 7 ] },
		      [ '2', 'A' ] => { max => 7, auto_create => [ 0 .. 7 ] }
		    ],
	       },
	    collected_type => 'node',
	    config_class_name => 'Slave'
	  }
      ]
  );

ok(1,"compiled");

my $inst = $model->instance (root_class_name => 'Master', 
				 instance_name => 'test1');
ok($inst,"created dummy instance") ;

my $root = $inst -> config_root ;
my $macro = $root->fetch_element('macro') ;

is($macro->store('A'),'A',"Set macro to A") ;
is($macro->fetch(),'A',"Check macro") ;

my $warped_hash = $root->fetch_element('warped_hash') ;
ok( $warped_hash->fetch_with_id('1'), "Set one slave" );

my $res = eval { $warped_hash->fetch_with_id('2'); };
ok( $@, "Set second slave (normal error)" );
print "normal error:", $@, "\n" if $trace;

is($macro->store('B'),'B',"Set macro to B") ;
ok( $warped_hash->fetch_with_id('2'), "Set second slave" );

$res = eval { $warped_hash->fetch_with_id('3'); };
ok( $@, "Set third slave (normal error)" );
print "normal error:", $@, "\n" if $trace;

is($macro->store('C'),'C',"Set macro to C (warp_reset)") ;
ok( $warped_hash->fetch_with_id('3'), "Set third slave" );

$res = eval { $warped_hash->fetch_with_id('4'); };
ok( $@, "Set fourth slave (normal error)" );
print "normal error:", $@, "\n" if $trace;

eval {$macro->store('B') ;} ;
ok( $@, "Set macro to B: limit max to 2 when the hash has id '3'" );
print "normal error:", $@, "\n" if $trace;

# so remove one item
$warped_hash->delete('3') ;
# and retry

is($macro->store('B'),'B',"Set macro to B (limit max to 2)") ;

is_deeply( [ $warped_hash->get_all_indexes ], [qw/1 2/],
	   "check reduced key set") ;

my $multi_warp = $root->fetch_element('multi_warp') ;

is( $multi_warp->max, 3, "check multi_warp default max" );

my $multi_auto_create = $root->fetch_element('multi_auto_create') ;
is( $multi_auto_create->max,
    3, "check multi_auto_create default max" );

is( $root->fetch_element('version')->store(2), 2, 'set version to 2') ;
is( $macro->store('C'),'C','set macro to C') ;

is_deeply( $multi_warp->default ,
	   [0 .. 7],
	   "check multi_warp default index parameter"
	 );
is_deeply( [ sort $multi_warp->get_all_indexes ] ,
	   [0 .. 7],
	   "check multi_warp default key set with different warp master"
	 );

is($multi_warp->fetch_with_id('5')->fetch_element('X')->store('Av'),
   'Av', "store Av in X");

$root->load(step => 'multi_warp:5 X=Av') ;

is($root->grab_value('multi_warp:5 X'),'Av','check X value') ;


is( $multi_warp->max, 7, "check multi_warp warped_hash max" );

is_deeply( [ sort $multi_auto_create->get_all_indexes ],
	   [0 .. 7],
	   "check multi_auto_create default key set with different warp master"
);


$root->load(step => 'multi_auto_create:5 X=Av');

is( $root->grab_value('multi_auto_create:5 X'), 'Av', "check X value" );

is( $multi_auto_create->max,
    7, "check multi_auto_create warped_hash max" );

# remove one item to avoid error when setting macro to A
$warped_hash->delete('2') ;

ok( $macro->store('A'), "assign new value to warp master (same effect)" );

is( $root->grab_value('multi_warp:5 X'), 'Av',
    "check X value after assign" );