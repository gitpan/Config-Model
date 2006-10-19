# -*- cperl -*-
# $Author: ddumont $
# $Date: 2006/10/11 11:43:16 $
# $Name:  $
# $Revision: 1.7 $

use ExtUtils::testlib;
use Test::More tests => 6;
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
			     model_file => 't/big_model.pm',
			     instance_name => 'test1');
ok($inst,"created dummy instance") ;

my $root = $inst -> config_root ;
ok($root,"Config root created") ;

my $step = 'std_id:ab X=Bv - std_id:bc X=Av - std_id:"b d " X=Av '
  .'- a_string="toto tata" '
  .'lista=a,b,c,d olist:0 X=Av - olist:1 X=Bv - listb=b,c,d';
ok( $root->load( step => $step, permission => 'intermediate' ),
  "set up data in tree with '$step'");

my $cds = $root->dump_tree;

print "cds string:\n$cds" if $trace ;

my $expect = <<'EOF' ;
std_id:"b d "
  X=Av -
std_id:ab
  X=Bv -
std_id:bc
  X=Av -
lista=a,b,c,d
listb=b,c,d
olist:0
  X=Av -
olist:1
  X=Bv -
warp
  sub_slave
    sub_slave - - -
a_string="toto tata" -
EOF

is($cds,$expect,"check dump of only customized values ") ;

$cds = $root->dump_tree( full_dump => 1 );
print "cds string:\n$cds" if $trace  ;

$expect = <<'EOF' ;
std_id:"b d "
  X=Av
  DX=Dv -
std_id:ab
  X=Bv
  DX=Dv -
std_id:bc
  X=Av
  DX=Dv -
lista=a,b,c,d
listb=b,c,d
olist:0
  X=Av
  DX=Dv -
olist:1
  X=Bv
  DX=Dv -
warp
  sub_slave
    sub_slave - - -
string_with_def="yada yada"
a_string="toto tata"
int_v=10 -
EOF

is($cds,$expect,"check dump of all values ") ;


