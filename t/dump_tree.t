# -*- cperl -*-
# $Author: ddumont $
# $Date: 2008-10-29 14:10:01 +0100 (mer 29 oct 2008) $
# $Revision: 786 $

use ExtUtils::testlib;
use Test::More tests => 13;
use Config::Model;

use warnings;
no warnings qw(once);

use strict;

use vars qw/$model/;

$model = Config::Model -> new (legacy => 'ignore',) ;

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

$inst->preset_start ;

$root->fetch_element('hidden_string',undef,1)->store('hidden value');

my $step = 'std_id:ab X=Bv '
  .'! lista=a,b listb=b ' ;
ok( $root->load( step => $step, permission => 'intermediate' ),
    "preset data in tree with '$step'");

$inst->preset_stop ;

$step = 'std_id:ab X=Bv - std_id:bc X=Av - std_id:"b d " X=Av '
  .'- a_string="toto \"titi\" tata" '
  .'lista=a,b,c,d olist:0 X=Av - olist:1 X=Bv - listb=b,c,d '
  . '! hash_a:X2=x hash_a:Y2=xy  hash_b:X3=xy my_check_list=X2,X3' ;
ok( $root->load( step => $step, permission => 'intermediate' ),
  "set up data in tree with '$step'");

is_deeply([ sort $root->fetch_element('std_id')->get_all_indexes ],
	  ['ab','b d ','bc'], "check std_id keys" ) ;

my $cds = $root->dump_tree;

print "cds string:\n$cds" if $trace ;

my $expect = <<'EOF' ;
std_id:ab -
std_id:"b d "
  X=Av -
std_id:bc
  X=Av -
lista=c,d
listb=c,d
hash_a:X2=x
hash_a:Y2=xy
hash_b:X3=xy
olist:0
  X=Av -
olist:1
  X=Bv -
a_string="toto \"titi\" tata"
my_check_list=X2,X3 -
EOF

$cds =~ s/\s+\n/\n/g;
is_deeply( [split /\n/,$cds], [split /\n/,$expect], 
	   "check dump of only customized values ") ;

$cds = $root->dump_tree( full_dump => 1 );
print "cds string:\n$cds" if $trace  ;

$expect = <<'EOF' ;
std_id:ab
  X=Bv
  DX=Dv -
std_id:"b d "
  X=Av
  DX=Dv -
std_id:bc
  X=Av
  DX=Dv -
lista=a,b,c,d
listb=b,c,d
hash_a:X2=x
hash_a:Y2=xy
hash_b:X3=xy
olist:0
  X=Av
  DX=Dv -
olist:1
  X=Bv
  DX=Dv -
string_with_def="yada yada"
a_uniline="yada yada"
a_string="toto \"titi\" tata"
int_v=10
my_check_list=X2,X3 -
EOF

$cds =~ s/\s+\n/\n/g;
is_deeply( [split /\n/,$cds], [split /\n/,$expect], 
	   "check dump of all values ") ;

my $listb = $root->fetch_element('listb');
$listb->clear ;

$cds = $root->dump_tree( full_dump => 1 );
print "cds string:\n$cds" if $trace  ;

$expect = <<'EOF' ;
std_id:ab
  X=Bv
  DX=Dv -
std_id:"b d "
  X=Av
  DX=Dv -
std_id:bc
  X=Av
  DX=Dv -
lista=a,b,c,d
hash_a:X2=x
hash_a:Y2=xy
hash_b:X3=xy
olist:0
  X=Av
  DX=Dv -
olist:1
  X=Bv
  DX=Dv -
string_with_def="yada yada"
a_uniline="yada yada"
a_string="toto \"titi\" tata"
int_v=10
my_check_list=X2,X3 -
EOF

$cds =~ s/\s+\n/\n/g;
is_deeply( [split /\n/,$cds], [split /\n/,$expect], 
	   "check dump of all values after listb is cleared") ;


# check empty strings

my $a_s = $root->fetch_element('a_string');
$a_s->store("") ;

$expect = <<'EOF' ;
std_id:ab
  X=Bv
  DX=Dv -
std_id:"b d "
  X=Av
  DX=Dv -
std_id:bc
  X=Av
  DX=Dv -
lista=a,b,c,d
hash_a:X2=x
hash_a:Y2=xy
hash_b:X3=xy
olist:0
  X=Av
  DX=Dv -
olist:1
  X=Bv
  DX=Dv -
string_with_def="yada yada"
a_uniline="yada yada"
a_string=""
int_v=10
my_check_list=X2,X3 -
EOF

$cds = $root->dump_tree( full_dump => 1 );
print "cds string:\n$cds" if $trace  ;

$cds =~ s/\s+\n/\n/g;
is_deeply( [split /\n/,$cds], [split /\n/,$expect], 
	   "check dump of all values after a_string is set to ''") ;

# check preset values

$cds = $root->dump_tree( mode => 'preset' );
print "cds string:\n$cds" if $trace  ;

$expect = <<'EOF' ;
std_id:ab
  X=Bv -
std_id:"b d " -
std_id:bc -
lista=a,b
olist:0 -
olist:1 - -
EOF

$cds =~ s/\s+\n/\n/g;
is_deeply( [split /\n/,$cds], [split /\n/,$expect], 
	   "check dump of all preset values") ;

# shake warp stuff
my $tm = $root -> fetch_element('tree_macro') ;
map { $tm->store($_);} qw/XY XZ mXY XY mXY XZ/;

$cds = $root->dump_tree( full_dump => 1 );
print "cds string:\n$cds" if $trace  ;

like($cds,qr/hidden value/,"check that hidden value is shown (macro=XZ)") ;


# check that list of undef is not shown
map { $listb->fetch_with_id($_)->store(undef) } (0 .. 3);

$cds = $root->dump_tree( full_dump => 1 );
print "Empty listb dump:\n$cds" if $trace  ;

unlike($cds,qr/listb/,"check that listb containing undef values is not shown") ;
