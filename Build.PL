#
# This file is part of Config-Model
#
# This software is Copyright (c) 2011 by Dominique Dumont, Krzysztof Tyszecki.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
#    Copyright (c) 2005-2011 Dominique Dumont.
#
#    This file is part of Config-Model.
#
#    Config-Model is free software; you can redistribute it and/or
#    modify it under the terms of the GNU Lesser Public License as
#    published by the Free Software Foundation; either version 2.1 of
#    the License, or (at your option) any later version.
#
#    Config-Model is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#    Lesser Public License for more details.
#
#    You should have received a copy of the GNU Lesser Public License
#    along with Config-Model; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
#    02110-1301 USA

use Module::Build;

use warnings FATAL => qw(all);
use strict;
use File::Slurp qw/slurp/;
use Log::Log4perl qw(:easy) ;

Log::Log4perl->easy_init($WARN);

require 5.008;

print "\nIf you want to use the TermUI interface, you should install\n",
  "Term::ReadLine::Perl or Term::ReadLine::Gnu\n\n";

# check that pod docs are up-to-date
# this is redundant with work done by dzil. But this enable to re-build the 
# docs downstream.
system("perl -Ilib script/gen_class_pod.pl");

my @version_info = @ARGV ? ( dist_version => $ARGV[0] ) : ();

my %appli_files = map { ( $_, $_ ) } glob("lib/Config/Model/*.d/*");

my $build = Module::Build->new(
    module_name => 'Config::Model',
    @version_info,
    license       => 'lgpl',
    script_files  => ['config-edit'],
    appli_files   => \%appli_files,
    dist_abstract => 'Describe, edit and validate configuration data',
    dist_author   => 'Dominique Dumont (ddumont at cpan dot org)',

  'build_requires' => {
    'File::Slurp' => '0',
    'Module::Build' => '0.34',
    'Path::Class' => '0',
    'Probe::Perl' => '0',
    'Test::Command' => '0.08',
    'Test::Differences' => '0',
    'Test::Exception' => '0',
    'Test::More' => '0',
    'Test::Warn' => '0.11'
  },
  'configure_requires' => {
    'Module::Build' => '0.34'
  },
  'recommends' => {
    'Fuse' => '0'
  },
  'requires' => {
    'Any::Moose' => '0',
    'Carp::Assert::More' => '0',
    'DB_File' => '0',
    'Exception::Class' => '0',
    'File::HomeDir' => '0',
    'Hash::Merge' => '0.12',
    'IO::File' => '0',
    'LWP::Simple' => '0',
    'Log::Log4perl' => '1.11',
    'MouseX::NativeTraits' => '0',
    'MouseX::StrictConstructor' => '0',
    'Parse::RecDescent' => '1.90.0',
    'Pod::POM' => '0',
    'Scalar::Util' => '0',
    'Term::ReadLine' => '0',
    'Text::Autoformat' => '0',
    'YAML::Any' => '0.303'
  },

    meta_merge => {
        resources => {
            homepage => 'http://config-model.wiki.sourceforge.net',
            MailingList =>
              'https://lists.sourceforge.net/lists/listinfo/config-model-users',
            repository =>
              'http://config-model.hg.sourceforge.net:8000/hgroot/config-model/config-model',
        },
    },

    # cleanup required by t/auto_read.t
    # PreGrammar.pm is created by t/value_computer.t
    add_to_cleanup => [ qw/PreGrammar.pm wr_root r_root/ ],
);

$build->add_build_element('pl');
$build->add_build_element('appli');

$build->create_build_script;
