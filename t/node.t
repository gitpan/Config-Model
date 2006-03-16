# -*- cperl -*-
# $Author: ddumont $
# $Date: 2006/02/16 13:09:43 $
# $Name:  $
# $Revision: 1.3 $

use ExtUtils::testlib;
use Test::More tests => 49;
use Config::Model;

use warnings;
no warnings qw(once);

use strict;

my $model = Config::Model -> new ;

$model->create_config_class 
  (
   name => 'Sarge',
   permission => [ [qw/Y/] => 'intermediate',  # default
		   X => 'master' 
		 ],
   status    => [ X => 'deprecated' ], #could be obsolete, standard
   description => [ X => 'X-ray' ],

   element => [
	       [qw/X Y Z/] => {
			       type => 'leaf',
			       class => 'Config::Model::Value',
			       value_type => 'enum',
			       choice     => [qw/Av Bv Cv/]
			      }
	      ],
  );

$model->create_config_class 
  (
   name => 'Captain',
   permission => [ bar => 'intermediate' ],
   element => [
	       bar => { type => 'node', 
			config_class_name => 'Sarge' ,
			init_step => [ Y => 'Bv' ]
		      }
	      ]
  );

$model ->create_config_class 
  (
   name => "Master",
   permission => [[qw/captain many array_args hash_args/] => 'intermediate' ],
   level     => [qw/captain/ => 'important' ] ,
   element => [
		captain => { 
			 type => 'node',
			 config_class_name => 'Captain',
			 init_step => [ 'bar X' => 'Av' ]
			},
		[qw/array_args hash_args/] 
		=> { type => 'node',
		     config_class_name => 'Captain',
		     init_step 
		     => [ 'bar X' 
			  => [ choice => [qw/Av Bv Cv Dv/] ] 
			]
		   },
	       ],
   class_description => "Master description",
   description => [
		   captain       => "officer",
		   array_args => 'not officer'
		  ]
  );

my $trace = shift || 0;

$::verbose = 1 if $trace > 1;
$::debug = 1 if $trace > 2 ;

ok(1,"Model created") ;

my $instance = $model->instance (root_class_name => 'Master', 
				 instance_name => 'test1');

ok(1,"Instance created") ;

my $root = $instance -> config_root ;

ok($root,"Config root created") ;

is( $root->config_class_name, 'Master', "Created Master" );

is_deeply( [ sort $root->get_element_name(for => 'intermediate') ],
	   [qw/array_args captain hash_args/], "check Master elements");

is_deeply( [ sort $root->get_element_name(for => 'advanced') ],
	   [qw/array_args captain hash_args/], "check Master elements");

is_deeply( [ sort $root->get_element_name(for => 'master') ],
	   [qw/array_args captain hash_args/], "check Master elements");

my $w = $root->fetch_element('captain') ;
ok( $w, "Created Captain" );

is($w->config_class_name,'Captain',"test class_name") ;

is($w->element_name,'captain',"test element_name") ;
is($w->name,'captain',"test name") ;
is($w->location,'captain',"test captain location") ;

my $b = $w->fetch_element('bar');
ok( $b, "Created Sarge" );

is($b->get_element_property(property => 'permission', element => 'Y'),
   'intermediate',"check Y permission") ;
is($b->get_element_property(property => 'permission',element => 'Z'),
   'intermediate',"check Z permission") ;
is($b->get_element_property(property => 'permission',element => 'X'),
   'master',      "check X permission") ;

is( $b->fetch_element_value('X'), 'Av',  "test X value" );
is( $b->fetch_element_value('Y'), 'Bv',  "test Y value" );
is( $b->fetch_element_value('Z'), undef, "test Z value" );

eval { $b->fetch_element('Z','user');} ;
ok($@,"fetch_element with unexpected permission") ;
like($@,qr/Unexpected permission/,"check error message") ;

eval { $b->fetch_element('X','intermediate');} ;
ok($@,"fetch_element with unexpected permission") ;
like($@,qr/restricted element/,"check error message") ;

$root->fetch_element('array_args')->fetch_element('bar')
  ->store_element_value( X => 'Dv' );

is( $root->fetch_element('array_args')->fetch_element('bar')
    ->fetch_element_value( 'X'),
    'Dv', "Testing X modif done through array ref constructor arg" );

is( $root->fetch_element('array_args')
    ->get_element_property(property => 'permission',element => 'bar'),
    'intermediate' );
is( $root->fetch_element('array_args')->fetch_element('bar')
    ->get_element_property(property => 'permission',element => 'X'), 
    'master' );

my $tested = $root->fetch_element('hash_args')->fetch_element('bar');

$tested->store_element_value( X => 'Dv');

is($tested->config_class_name,  'Sarge',"test bar config_class_name") ;
is($tested->element_name,'bar'  ,"test bar element_name") ;
is($tested->name,        'hash_args bar' ,"test bar name") ;
is($tested->location,    'hash_args bar' ,"test bar location") ;

is( $tested->fetch_element_value('X'),
    'Dv', "Testing X modif done through hash ref constructor arg" );
is( $tested->get_element_property(property => 'permission',element => 'X'),
    'master',
    "checking X permission");

my $inst2 =  $model->instance (root_class_name => 'Master', 
			      instance_name => 'test2');

isa_ok( $inst2, 'Config::Model::Instance',
        "Created 2nd Master" );

isa_ok( $inst2->config_root, 'Config::Model::Node',
      "created 2nd tree");


# test help included with the model

is( $root->get_help, "Master description", "Test master global help" );

is( $root->get_help('captain'), "officer", "Test master slot help captain" );

is( $root->get_help('hash_args'),
    '', "Test master slot help hash_args" );

is( $tested->get_help('X'), "X-ray", "Test sarge slot help X" );

is($root->has_element('daughter'), 0 ,"Non-existing element" );


ok( $root->is_element_available(name =>'captain'), "test element" );

is( $root->get_element_property( property => 'level',element =>'hash_args' ),
    'normal',
    "test (non) importance" );

is( $root->get_element_property(property => 'level',element => 'captain' ),
    'important',
    "test importance" );

is( $root->set_element_property( property => 'level',element =>'captain',
				 value => 'hidden'), 
    'hidden',
    "test importance" );

is( $root->get_element_property(property => 'level',element => 'captain' ),
    'hidden',
    "test hidden" );

is( $root->reset_element_property( property => 'level',element =>'captain'), 
    'important',
    "test importance" );

map {
    my $key_label = defined $_->[0] ? $_->[0] : 'undef';
    is( $root->next_element($_->[0]), $_->[1], 
	"test next_element ($key_label)" );
} ( [ undef, 'captain'] ,
    [ '',    'captain'] ,
    [ qw/captain array_args/ ],
    [ qw/array_args hash_args/]
  ) ;