# -*- cperl -*-
# $Author: ddumont $
# $Date: 2006/07/19 12:25:23 $
# $Name:  $
# $Revision: 1.1 $

use ExtUtils::testlib;
use Test::More tests => 4;
use Config::Model;

use warnings;
no warnings qw(once);

use strict;

use vars qw/$model/;

$model = Config::Model -> new ;


my $arg = shift || '' ;
my $trace = $arg =~ /t/ ? 1 : 0 ;
$::verbose          = 1 if $arg =~ /v/;
$::debug            = 1 if $arg =~ /d/;
Config::Model::Exception::Any->Trace(1) if $arg =~ /e/;

ok(1,"compiled");

my $inst = $model->instance (root_class_name => 'Master', 
			     model_file    => 't/big_model.pm' ,
			     instance_name => 'test1');

ok($inst,"created dummy instance") ;

my $root = $inst -> config_root ;
ok($root,"Config root created") ;

my $step = 'std_id:ab X=Bv - std_id:bc X=Av - a_string="toto tata" '
  .'lista=a,b,c,d olist:0 X=Av - olist:1 X=Bv - listb=b,c,d';
ok( $root->load( step => $step, permission => 'intermediate' ),
  "set up data in tree with '$step'");

# no need to check more. The above command would have failed if
# the file containing the model was not loaded.