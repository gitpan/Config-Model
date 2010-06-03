# 
# This file is part of Config-Model
# 
# This software is Copyright (c) 2010 by Dominique Dumont.
# 
# This is free software, licensed under:
# 
#   The GNU Lesser General Public License, Version 2.1, February 1999
# 
package MyModuleBuilder;
use Module::Build;
@ISA = qw(Module::Build);

use Text::Template ;
my %models = ( popcon => [ 'PopCon', '/etc/popularity-contest.conf']) ;

sub process_tmpl_files {
  my $self = shift;
  print "process_tmpl_files called\n";
  my $template = Text::Template->new(SOURCE => 'config-edit.tmpl')
    or die "Couldn't construct template: $Text::Template::ERROR";

  foreach (keys %models) {
    my $v = $models{$_} ;
    my %vars = ( name => $_,  model => $v->[0], conf_file => $v->[1]) ;
    my $fout = "blib/script/config-edit-$_" ;
    print "Creating $fout\n";
    my $result = $template->fill_in( HASH => \%vars) ;
    if (defined $result) { 
      open (FOUT, "> $fout") || die "Can't open $fout:$!";
      print FOUT $result;
      close FOUT ;
      chmod 0755,$fout || die "Can't chmod $fout:$!";
    }
    else { die "Couldn't fill in template: $Text::Template::ERROR"  ; }
  }
}


1;
