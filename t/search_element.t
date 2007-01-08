# -*- cperl -*-
# $Author: ddumont $
# $Date: 2007/01/08 12:51:49 $
# $Name:  $
# $Revision: 1.5 $

use ExtUtils::testlib;
use Test::More tests => 15;
use Config::Model;

use warnings;
no warnings qw(once);

use strict;

use Data::Dumper;
# use Config::Model::ObjTreeScanner;

use vars qw/$model/;

$model = Config::Model -> new ;

my $trace = shift || 0;
$::verbose          = 1 if $trace =~ /v/;
$::debug            = 1 if $trace =~ /d/;

$Data::Dumper::Indent = 1 ;

ok(1,"compiled");

my $inst = $model->instance (root_class_name => 'Master', 
			     model_file => 't/big_model.pm',
			     instance_name => 'test1');
ok($inst,"created dummy instance") ;

my $root = $inst -> config_root ;


Config::Model::Exception::Any->Trace(1) if $trace =~ /e/;



my @data 
  = (
     [
      'Z',
      "std_id:foo",
      {
       'Z' => {'next_step' => 'Z'},
       'X' => {'next_step' => 'X'},
       'DX' => {'next_step' => 'DX'}
      }
     ],
     [
      'ab2',
      'warp',
      {
       'ab2' => {'next_step' => {'warp2' => {'next_class' => {'SubSlave2' => {'next_step' => 'ab2'}}}, 'sub_slave' => {'next_step' => {'sub_slave' => {'next_step' => 'ab2'}}}}},

       'aa2' => {'next_step' => {'warp2' => {'next_class' => {'SubSlave2' => {'next_step' => 'aa2'}}}, 'sub_slave' => {'next_step' => {'sub_slave' => {'next_step' => 'aa2'}}}}}, 

       'X' => {'next_step' => {'std_id' => {'next_step' => 'X'}}},
       'ac' => {'next_step' => {'sub_slave' => {'next_step' => 'ac'}}},
       'Y' => {'next_step' => 'Y'},
       'DX' => {'next_step' => {'std_id' => {'next_step' => 'DX'}}},

       'Z' => {'next_step' => {'warp2' => {'next_class' => {'SubSlave2' => {'next_step' => 'Z'}}}, 'std_id' => {'next_step' => 'Z'}, 'sub_slave' => {'next_step' => {'sub_slave' => {'next_step' => 'Z'}}}}},


       'ab' => {'next_step' => {'sub_slave' => {'next_step' => 'ab'}}},

         'ad2' => {'next_step' => {'warp2' => {'next_class' => {'SubSlave2' => {'next_step' => 'ad2'}}}, 'sub_slave' => {'next_step' => {'sub_slave' => {'next_step' => 'ad2'}}}}}, 

       'ad' => {'next_step' => {'sub_slave' => {'next_step' => 'ad'}}},
       'aa' => {'next_step' => {'sub_slave' => {'next_step' => 'aa'}}},
       'ac2' => {'next_step' => {'warp2' => {'next_class' => {'SubSlave2' => {'next_step' => 'ac2'}}}, 'sub_slave' => {'next_step' => {'sub_slave' => {'next_step' => 'ac2'}}}}},


      }
     ], 

     ['Z', '!', 
      {
       'string_with_def' => {'next_step' => 'string_with_def'},

       'aa2' => {'next_step' => {'slave_y' => {'next_step' => {'warp2' => {'next_class' => {'SubSlave2' => {'next_step' => 'aa2'}}}, 'sub_slave' => {'next_step' => {'sub_slave' => {'next_step' => 'aa2'}}}}}, 'warp' => {'next_class' => {'SlaveY' => {'next_step' => {'warp2' => {'next_class' => {'SubSlave2' => {'next_step' => 'aa2'}}}, 'sub_slave' => {'next_step' => {'sub_slave' => {'next_step' => 'aa2'}}}}}}}}},

       'Y' => {'next_step' => {'slave_y' => {'next_step' => 'Y'}, 'warp' => {'next_class' => {'SlaveY' => {'next_step' => 'Y'}}}}},

       'DX' => {'next_step' => {'slave_y' => {'next_step' => {'std_id' => {'next_step' => 'DX'}}}, 'olist' => {'next_step' => 'DX'}, 'warp' => {'next_class' => {'SlaveZ' => {'next_step' => 'DX'}, 'SlaveY' => {'next_step' => {'std_id' => {'next_step' => 'DX'}}}}}, 'std_id' => {'next_step' => 'DX'}}},

       'Z' => {'next_step' => {'slave_y' => {'next_step' => {'warp2' => {'next_class' => {'SubSlave2' => {'next_step' => 'Z'}}}, 'std_id' => {'next_step' => 'Z'}, 'sub_slave' => {'next_step' => {'sub_slave' => {'next_step' => 'Z'}}}}}, 'olist' => {'next_step' => 'Z'}, 'warp' => {'next_class' => {'SlaveZ' => {'next_step' => 'Z'}, 'SlaveY' => {'next_step' => {'warp2' => {'next_class' => {'SubSlave2' => {'next_step' => 'Z'}}}, 'std_id' => {'next_step' => 'Z'}, 'sub_slave' => {'next_step' => {'sub_slave' => {'next_step' => 'Z'}}}}}}}, 'std_id' => {'next_step' => 'Z'}}},

       'ad2' => {'next_step' => {'slave_y' => {'next_step' => {'warp2' => {'next_class' => {'SubSlave2' => {'next_step' => 'ad2'}}}, 'sub_slave' => {'next_step' => {'sub_slave' => {'next_step' => 'ad2'}}}}}, 'warp' => {'next_class' => {'SlaveY' => {'next_step' => {'warp2' => {'next_class' => {'SubSlave2' => {'next_step' => 'ad2'}}}, 'sub_slave' => {'next_step' => {'sub_slave' => {'next_step' => 'ad2'}}}}}}}}},

       'tree_macro' => {'next_step' => 'tree_macro'},

       'a_string' => {'next_step' => 'a_string'},

       'ad' => {'next_step' => {'slave_y' => {'next_step' => {'sub_slave' => {'next_step' => 'ad'}}}, 'warp' => {'next_class' => {'SlaveY' => {'next_step' => {'sub_slave' => {'next_step' => 'ad'}}}}}}},

       'aa' => {'next_step' => {'slave_y' => {'next_step' => {'sub_slave' => {'next_step' => 'aa'}}}, 'warp' => {'next_class' => {'SlaveY' => {'next_step' => {'sub_slave' => {'next_step' => 'aa'}}}}}}},

       'ac2' => {'next_step' => {'slave_y' => {'next_step' => {'warp2' => {'next_class' => {'SubSlave2' => {'next_step' => 'ac2'}}}, 'sub_slave' => {'next_step' => {'sub_slave' => {'next_step' => 'ac2'}}}}}, 'warp' => {'next_class' => {'SlaveY' => {'next_step' => {'warp2' => {'next_class' => {'SubSlave2' => {'next_step' => 'ac2'}}}, 'sub_slave' => {'next_step' => {'sub_slave' => {'next_step' => 'ac2'}}}}}}}}},

       'lista' => {'next_step' => 'lista'},

       'hash_b' => {'next_step' => 'hash_b'},

       'ab2' => {'next_step' => {'slave_y' => {'next_step' => {'warp2' => {'next_class' => {'SubSlave2' => {'next_step' => 'ab2'}}}, 'sub_slave' => {'next_step' => {'sub_slave' => {'next_step' => 'ab2'}}}}}, 'warp' => {'next_class' => {'SlaveY' => {'next_step' => {'warp2' => {'next_class' => {'SubSlave2' => {'next_step' => 'ab2'}}}, 'sub_slave' => {'next_step' => {'sub_slave' => {'next_step' => 'ab2'}}}}}}}}},

       'int_v' => {'next_step' => 'int_v'},

       'listb' => {'next_step' => 'listb'},

       'my_reference' => {'next_step' => 'my_reference'},

       'X' => {'next_step' => {'slave_y' => {'next_step' => {'std_id' => {'next_step' => 'X'}}}, 'olist' => {'next_step' => 'X'}, 'warp' => {'next_class' => {'SlaveZ' => {'next_step' => 'X'}, 'SlaveY' => {'next_step' => {'std_id' => {'next_step' => 'X'}}}}}, 'std_id' => {'next_step' => 'X'}}},

       'ac' => {'next_step' => {'slave_y' => {'next_step' => {'sub_slave' => {'next_step' => 'ac'}}}, 'warp' => {'next_class' => {'SlaveY' => {'next_step' => {'sub_slave' => {'next_step' => 'ac'}}}}}}},

       'ab' => {'next_step' => {'slave_y' => {'next_step' => {'sub_slave' => {'next_step' => 'ab'}}}, 'warp' => {'next_class' => {'SlaveY' => {'next_step' => {'sub_slave' => {'next_step' => 'ab'}}}}}}},

       'my_check_list' => {'next_step' => 'my_check_list'},
      
       'hash_a' => {'next_step' => 'hash_a'},
      }
     ]
    ) ;

foreach my $item (@data) {
    next unless @$item == 3 ;
    my $node = $root->grab($item->[1]) ;
    my $searcher = $node->search_element(element => $item->[0]);

    is_deeply( $searcher->{data}, $item->[2] , 
	       "verify search data on ".$node->config_class_name) ||
		 print Dumper $searcher->{data} ;
}

my $searcher = $root->search_element(element => 'X');
$root->load("tree_macro=XZ") ;

my $step = $searcher->next_step() ;
is_deeply($step, [qw/olist slave_y std_id warp/],'check first step') ;

my $obj = $searcher->choose('warp') ;
is($obj->name,'warp', 'check choosen object') ;

my $target = $searcher->auto_choose(sub{}, sub {}) ;
is($target->name,'warp X', 'check auto choosen object for X') ;

$step = $searcher->next_step() ;
is_deeply($step, [],'check that no more steps are left') ;

# no user choice to look for aa
$root->load("tree_macro=XY") ;
$searcher = $root->search_element(element => 'aa');
$searcher->choose('warp') ;
$target = $searcher->auto_choose(sub{}, sub {}) ;
is($target->name,'warp sub_slave aa', 'check auto choosen object for aa') ;

$searcher = $root->search_element(element => 'DX');
$root->load("tree_macro=XZ") ;
my $cb1 = sub {
    my $object = shift ;
    is($object->config_class_name, 'Master', 
       'check object of element call-back (DX))');
    is_deeply([@_], [qw/olist slave_y std_id warp/],
	      'check param of element call-back (DX)') ;
    return 'warp' ;
} ;

$target = $searcher->auto_choose($cb1, sub{}) ;
is($target->name,'warp DX', 'check auto choosen object for DX (warp)') ;

# restart and try through olist
$searcher->reset ;
$target = $searcher->auto_choose(sub{'olist'}, sub {return 1;}) ;

is($target->name, 'olist:1 DX',
	  'check auto_choose target for DX (olist)') ;

# restart and try through std_d
$searcher->reset ;
$target = $searcher->auto_choose(sub{'std_id'}, sub {return 'foo';}) ;

is($target->name, 'std_id:foo DX',
	  'check auto_choose target for DX (std_id)') ;

