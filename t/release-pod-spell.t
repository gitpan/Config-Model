#!perl
#
# This file is part of Config-Model
#
# This software is Copyright (c) 2011 by Dominique Dumont, Krzysztof Tyszecki.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#

BEGIN {
  unless ($ENV{RELEASE_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for release candidate testing');
  }
}


use Test::More;

eval "use Pod::Wordlist::hanekomu";
plan skip_all => "Pod::Wordlist::hanekomu required for testing POD spelling"
  if $@;

eval "use Test::Spelling";
plan skip_all => "Test::Spelling required for testing POD spelling"
  if $@;


add_stopwords(<DATA>);
all_pod_files_spelling_ok('lib');
__DATA__
cpan
debian
dpkg
redhat
redhat's
Dumont
ddumont
krzysztof
tyszecki
augeas
gmail
webmin
fstab
lan
inet
scriplets
xorg
xserver
AnyThing
AutoRead
CTRL
ini
cds
yaml
UI
HashId
firstkey
nextkey
shellvar
WarpThing
AnyId
ListId
ObjTreeScanner
OpenSsh
json
Xorg
CheckList
warper
uncheck
autoadd
conf
