#
# This file is part of Config-Model
#
# This software is Copyright (c) 2010 by Dominique Dumont, Krzysztof Tyszecki.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#

package Config::Model::Backend::Debian::DpkgSyntax ;
BEGIN {
  $Config::Model::Backend::Debian::DpkgSyntax::VERSION = '1.221';
}

use Moose::Role ;

use Carp;
use Config::Model::Exception ;
use Log::Log4perl qw(get_logger :levels);

use base qw/Config::Model::Backend::Any/;

my $logger = get_logger("Backend::Debian::Dpkg") ;

sub parse_dpkg_file {
    my $self = shift ;
    my $fh = shift;
    my @res ; # list of list (section, [keyword, value])

    my $field;
    my $store_ref ;
    my $store_list = [] ;

    foreach (<$fh>) {
        if (/^([\w\-]+):/) {
            my ($field,$text) = split /\s*:\s*/,$_,2 ;

	    $text = "other\n" if $field =~ /license/i and $text =~ /^\s*$/;
	    push @$store_list, $field, $text ;
	    chomp $$store_ref if defined $$store_ref; # remove trailing \n 
	    $store_ref = \$store_list->[$#$store_list] ;
        }
        elsif (/^\s*$/) {
            push @res, $store_list if @$store_list ; # don't store empty sections 
            $store_list = [] ;
        }
        elsif (/^\s+\.$/) {
            $$store_ref .= "\n" ;
        }
        elsif (s/^\s//) {
            $$store_ref .= $_ ;
        }
        else {
            $logger->error("Invalid line: $_\n");
        }
    }

    # store last section if not empty
    push @res, $store_list if @$store_list;
    $fh->close ;

    if ($logger->is_debug ) {
        my $i = 1 ;
        map { $logger->debug("Parse result section ".$i++.":\n'".join("','",@$_)."'") ;} @res ;
    }
    
    warn "No section found\n" unless @res ;
    
    return wantarray ? @res : \@res ;   
}

# input is [ section [ keyword => value | value_list ] ]
sub write_dpkg_file {
    my ($self, $ioh, $array_ref,$list_sep) = @_ ;

    map { $self->write_dpkg_section($ioh,$_,$list_sep) } @$array_ref ;
}

sub write_dpkg_section {
    my ($self, $ioh, $array_ref,$list_sep) = @_ ;

    my $i = 0;
    foreach (my $i=0; $i < @$array_ref; $i += 2 ) {
        my $name  = $array_ref->[$i] ;
        my $value = $array_ref->[$i + 1];
        my $label = "$name:" ;
        if (ref ($value)) {
            $label .= ' ';
            my $l = length ($label) ;
            $ioh -> print ($label.join( $list_sep . ' ' x $l , @$value ) . "\n");
        }
        else {
            $ioh->print ($label) ;
            $self->write_dpkg_text($ioh,$value) ;
        }
    }
    $ioh->print("\n");
}

sub write_dpkg_text {
     my ($self, $ioh, $text) = @_ ;

    return unless $text ;
    foreach (split /\n/,$text) {
        $ioh->print ( /\S/ ? " $_\n" : " .\n") ;
    }
}

1;

__END__

=head1 NAME

Config::Model::Backend::Debian::DpkgSyntax - Role to read and write files with Dpkg syntax

=head1 VERSION

version 1.221

=head1 SYNOPSIS

  # in Dpkg dedicated backend class
  

=head1 DESCRIPTION

This module is a Moose role to add capacity to read and write dpkg control files
to Config::Model backend classes.

=head1

=head2 parse_dpkg_file ( file_handle )

Read a control file from the file_handle and returns a nested list (or a list 
ref) containing data from the file.

The returned list is of the form :

 [
   # section 1
   [ keyword1 => value1, # for text or simple values
     keyword2 => value2, # etc 
   ],
   # section 2
   [ ... ]
   # etc ...
 ]

=head2 write_dpkg_file ( io_handle, list_ref, list_sep )

Munge the passed list ref into a string compatible with control files
and write it in the passed file handle.

The input is a list of list in a form similar to the one generated by
L<parse_dpkg_file>:

 [ section [ keyword => value | value_list ] ]

Except that the value may be a SCALAR or a list ref. In case, of a list ref, the list 
items will be joined with the value C<list_sep> before being written.

For instance the following code :

 my $ref = [ [ Foo => 'foo value' , Bar => [ qw/v1 v2/ ] ];
 write_dpkg_file ( $ioh, $ref, ', ' )

will yield:

 Foo: foo value
 Bar: v1, v2

=head1 AUTHOR

Dominique Dumont, (ddumont at cpan dot org)

=head1 SEE ALSO

L<Config::Model>, 
L<Config::Model::AutoRead>, 
L<Config::Model::Backend::Any>, 

=cut