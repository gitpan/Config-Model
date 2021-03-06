# -*- cperl -*-

use warnings ;

use ExtUtils::testlib;
use Test::More;
use Test::Differences;
use Test::Memory::Cycle;
use Config::Model;
use Log::Log4perl qw(:easy);

use strict;

my ( $log, $show ) = (0) x 3;

my $arg = shift || '';

my $trace = $arg =~ /t/ ? 1 : 0;
$log     = 1 if $arg =~ /l/;
$show    = 1 if $arg =~ /s/;
Config::Model::Exception::Any->Trace(1) if $arg =~ /e/;

my $home = $ENV{HOME} || "";
my $log4perl_user_conf_file = "$home/.log4config-model";

if ( $log and -e $log4perl_user_conf_file ) {
    Log::Log4perl::init($log4perl_user_conf_file);
}
else {
    Log::Log4perl->easy_init( $arg =~ /l/ ? $DEBUG : $WARN );
}

ok( 1, "Compilation done" );

# minimal set up to get things working
my $model = Config::Model->new( legacy => 'ignore', );
$model->create_config_class(
    name    => 'SlaveY',
    element => [
        [qw/X Y/] => {
            type       => 'leaf',
            value_type => 'enum',
            choice     => [qw/Av Bv Cv/],
            warp       => {
                follow => '- - v_macro',
                rules  => {
                    A => { default => 'Av' },
                    B => { default => 'Bv' } } }
        },
        [qw/a_string a_long_string another_string/] => {
            type       => 'leaf',
            mandatory  => 1,
            value_type => 'string'
        },

    ] );

$model->create_config_class(
    name    => 'SlaveZ',
    element => [
        [qw/X Z/] => {
            type       => 'leaf',
            value_type => 'enum',
            choice     => [qw/Av Bv Cv/],
            warp       => {
                follow => '! v_macro',
                rules  => {
                    A => { default => 'Av' },
                    B => { default => 'Bv' } } } } ] );

$model->create_config_class(
    name    => 'Master',
    element => [
        v_macro => {
            type       => 'leaf',
            value_type => 'enum',
            choice     => [qw/A B/]
        },
        b_macro    => { type => 'leaf', value_type => 'boolean' },
        tree_macro => {
            type       => 'leaf',
            value_type => 'enum',
            choice     => [qw/XY XZ mXY W AR/]
        },

        'a_hash_of_warped_nodes' => {
            type       => 'hash',
            index_type => 'string',
            level      => 'hidden',
            warp       => {
                follow => '! tree_macro',
                rules  => {
                    XY  => { level => 'normal', },
                    mXY => {
                        level      => 'normal',
                    },
                    XZ => { level => 'normal', },
                }
            },
            cargo => {
                type   => 'warped_node',
                follow => '! tree_macro',
                morph  => 1,
                rules  => {
                    XY  => { config_class_name => 'SlaveY', },
                    mXY => {
                        config_class_name => 'SlaveY',
                    },
                    XZ => { config_class_name => 'SlaveZ' } }
            },
        },
        'a_warped_node' => {
            type   => 'warped_node',
            follow => '! tree_macro',
            morph  => 1,
            rules  => {
                XY  => { config_class_name => ['SlaveY'], },
                mXY => {
                    config_class_name => 'SlaveY',
                },
                XZ => { config_class_name => 'SlaveZ' } }
        },
        bool_object => {
            type   => 'warped_node',
            follow => '! b_macro',
            rules  => { 1 => { config_class_name => 'SlaveY' }, }
        },
    ] );

ok( 1, "compiled" );

my $inst = $model->instance(
    root_class_name => 'Master',
    instance_name   => 'test1'
);
ok( $inst, "created dummy instance" );

my $root = $inst->config_root;

my $tm = $root->fetch_element('tree_macro');
$tm->store('AR');

is( $root->is_element_available('a_warped_node'), 0, 'check that a_warped_node is not accessible' );

is( $root->is_element_available('a_hash_of_warped_nodes'),
    0, 'check that a_hash_of_warped_nodes is not available' );

eval {
    $root->fetch_element('a_hash_of_warped_nodes')->fetch_with_id(1)->fetch_element('X')
        ->store('coucou');
};
ok( $@, 'test stored on a warped node element (should fail)' );
print "Normal error:\n", $@ if $trace;

is( $root->fetch_element('tree_macro')->store('XY'), 1, 'set master->tree_macro to XY' );

is( $root->fetch_element('a_warped_node')->is_accessible,
    1, 'check that a_warped_node is accessible' );

my $ahown = $root->fetch_element('a_hash_of_warped_nodes');
is( $ahown->fetch_with_id(234)->config_class_name,
    'SlaveY', "reading a_hash_of_warped_nodes (is SlaveY because tree_macro was set)" );

is( $root->fetch_element('tree_macro')->store('XZ'), 1, 'set master->tree_macro to XZ' );

is( $ahown->fetch_with_id(234)->config_class_name,
    'SlaveZ', "reading a_hash_of_warped_nodes (is SlaveZ because tree_macro was set)" );

is( $ahown->fetch_with_id(234)->fetch_element('X')->fetch,
    undef, 'reading master a_hash_of_warped_nodes:234 X (undef)' );

is( $root->fetch_element('v_macro')->store('A'), 1, 'set master v_macro to A' );

map {
    is( $ahown->fetch_with_id(234)->fetch_element($_)->fetch,
        'Av', "reading master a_hash_of_warped_nodes:234 $_ (default value)" );
} qw/X Z/;

map {
    is( $ahown->fetch_with_id(234)->fetch_element($_)->store('Cv'),
        1, "Set master a_hash_of_warped_nodes:234 $_ to Cv" );
} qw/X Z/;

is( $root->fetch_element('tree_macro')->store('mXY'),
    1, 'set master->tree_macro to mXY (with morphing which looses Z element)...' );

is( $ahown->fetch_with_id(234)->fetch_element('X')->fetch, 'Cv', "... X value was kept ..." );

is( $ahown->fetch_with_id(234)->fetch_element('Y')->fetch, 'Av', "... Y is back to default value" );

is( $root->fetch_element('v_macro')->store('B'), 1, 'set master v_macro to B' );

is( $ahown->fetch_with_id(234)->fetch_element('X')->fetch, 'Cv', "... X value was kept ..." );

is( $ahown->fetch_with_id(234)->fetch_element('Y')->fetch, 'Bv', "... Y is to new default value" );

# TBD
#print "Testing dump on warped object\n" if $trace;
#my $dump = cute_dump( object => $master );
#ok( $dump, qr/ X = Cv/ );

my $warped_node = $root->fetch_element('a_warped_node');
isa_ok( $warped_node, "Config::Model::WarpedNode", "created warped node" );

is( $ahown->fetch_with_id(234)->element_name,
    'a_hash_of_warped_nodes', 'Check element name of warped node' );
is( $ahown->fetch_with_id(234)->index_value, '234', 'Check index value of warped node' );

# should also check that info was passed to actual node below (data
# element)
is( $ahown->fetch_with_id(234)->element_name,
    'a_hash_of_warped_nodes', 'Check element name of actual node below warped node' );
is( $ahown->fetch_with_id(234)->index_value,
    '234', 'Check index value of actual node below warped node' );

$ahown->copy( 234, 2345 );
print $root->dump_tree( check => 'no' ) if $trace;
is(
    $ahown->fetch_with_id(234)->fetch_element_value('X'),
    $ahown->fetch_with_id(2345)->fetch_element_value('X'),
    "check that has copy works on warped_node"
);

is( $root->fetch_element('tree_macro')->store('W'), 1,
    'set master->tree_macro to W (warp out)...' );

eq_or_diff(
    [ $root->get_element_name() ],
    [qw/v_macro b_macro tree_macro/],
    'reading elements of root after warp out'
);

eq_or_diff(
    [ $root->get_element_name() ],
    [qw/v_macro b_macro tree_macro/],
    'reading elements of root after warp out'
);

is( $root->fetch_element('b_macro')->store(1),
    1, 'set master->b_macro to 1 (warp in bool_object)...' );

$root->fetch_element('b_macro')->store(1);

is( $root->fetch_element('bool_object')->config_class_name,
    'SlaveY', 'check theorical bool_object type...' );

memory_cycle_ok( $model, "mem cycle test" );

done_testing;
