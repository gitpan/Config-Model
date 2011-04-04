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
Bzr
CTRL
Cvs
DEP
DFSG
DM
Darcs
HOSTID
Indep
LGPL
MAILTO
MTA
MTA's
Mtn
OpenSSL
PopCon
Pre
SUBMITURLS
Svn
USEHTTP
Vcs
Wiki
Xorg
anyid
anything
augeas
autoadd
autoread
browsable
bzr
cds
checklist
conf
contrib
cpan
ctrl
cvs
darcs
davfs
ddumont
debconf
debugfs
debian
dep
dfsg
dm
dpkg
dumont
firstkey
fs
fstab
gmail
hashid
hg
http
indep
inet
ini
iso
json
krzysztof
lan
lenny
lgpl
listid
mailfrom
mtn
nfs
nextkey
objtreescanner
openssh
pts
proc
redhat
redhat's
scriplets
shellvar
svn
tdeb
tyszecki
udeb
ui
uncheck
uniline
uploaders
usbfs
vcs
vfat
vcss
warper
warpthing
webmin
xorg
xserver
yaml
