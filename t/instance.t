# -*- cperl -*-
# $Date: 2006/02/06 12:34:35 $
# $Name:  $
# $Revision: 1.1 $

use warnings FATAL => qw(all);

use ExtUtils::testlib;
use Test::More;
use Config::Model;

BEGIN { plan tests => 19; }

use strict;

my $trace = shift || 0;

ok(1,"Compilation done");

$::verbose = 1 if $trace > 2;

my $model = Config::Model->new() ;
$model ->create_config_class 
  (
   name => "Master",
   element => [ ]
  ) ;

my $inst = $model->instance (root_class_name => 'Master', 
			     instance_name => 'test1');
ok($inst,"created dummy instance") ;

isa_ok( $inst->config_root , 'Config::Model::Node',"test config root class" );

$inst->push_no_value_check(qw/fetch store/);
is(     $inst->get_value_check('fetch'),0,
	"test value check, push fetch store" );
ok( not $inst->get_value_check('store') );
ok(     $inst->get_value_check('type') );
ok( not $inst->get_value_check('fetch_or_store') );

$inst->push_no_value_check(qw/type/);
ok( $inst->get_value_check('fetch'), "test value check, push type");
ok( $inst->get_value_check('store') );
ok( not $inst->get_value_check('type') );

$inst->pop_no_value_check();
is( $inst->get_value_check('fetch'),0, "test value check, pop type" );
ok( not $inst->get_value_check('store') );
ok( $inst->get_value_check('type') );

$inst->pop_no_value_check();
ok( $inst->get_value_check('fetch'), "test value check, pop fetch store");
ok( $inst->get_value_check('store') );
ok( $inst->get_value_check('type') );

is( $inst->data('test'),undef,"test empty private data ..." );
is( $inst->data( 'test', 'coucou' ), 'coucou', "store private data" );
is( $inst->data( 'test'), 'coucou', "retrieve private data" );
