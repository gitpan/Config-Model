#
# This file is part of Config-Model
#
# This software is Copyright (c) 2011 by Dominique Dumont, Krzysztof Tyszecki.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#

package Config::Model::Backend::Debian::Dpkg::Patch;
{
  $Config::Model::Backend::Debian::Dpkg::Patch::VERSION = '1.259';
}

use Any::Moose;

extends 'Config::Model::Backend::Any';

with 'Config::Model::Backend::Debian::DpkgSyntax';

use Carp;
use Config::Model::Exception;
use Log::Log4perl qw(get_logger :levels);
use IO::File;

my $logger = get_logger("Backend::Debian::Dpkg::Patch");

sub suffix { return ''; }

sub skip_open { 1;}

sub read {
    my $self = shift;
    my %args = @_;

    # args is:
    # object     => $obj,         # Config::Model::Node object
    # root       => './my_test',  # fake root directory, userd for tests
    # config_dir => /etc/foo',    # absolute path
    # file       => 'foo.conf',   # file name
    # file_path  => './my_test/etc/foo/foo.conf'
    # io_handle  => $io           # IO::File object
    # check      => yes|no|skip

    # io_handle is not defined as no file is specified in model

    my $patch_dir = $args{root} . $args{config_dir};
    my $check     = $args{check};
    my $node      = $args{object};

    my $patch_name = $node->index_value;

    my $patch_file = "$patch_dir/$patch_name";
    $logger->info("Parsing patch $patch_file");
    my $patch_io = IO::File->new($patch_file)
      || Config::Model::Exception::Syntax->throw(
        message => "cannot read patch $patch_file" );

    my ( $header, $diff ) = ( [],[] );
    my $target = $header;
    foreach ( $patch_io->getlines ) {
        $target = $diff if /^---/;    # beginning of patch
        push @$target, $_;
    }
    chomp @$header;

    my $c = $self->parse_dpkg_lines($header,$check);
    Config::Model::Exception::Syntax->throw(
        message => "More than one section in $patch_name header" )
      if @$c > 1;

    my $section = $c->[0];
    foreach ( my $i = 0 ; $i < $#$section ; $i += 2 ) {
        my $key = $section->[$i];
        my $v   = $section->[ $i + 1 ];
        if ( my $found = $node->find_element( $key, case => 'any' ) ) {
            my @elt = ($found);
            my @v = ( $found eq 'Description' ) ? ( split /\n/, $v, 2 ) : ($v);
            unshift @elt, 'Synopsis' if $found eq 'Description';
            foreach (@elt) {
                my $sub_v = shift @v;
                next unless defined $sub_v ;
                $logger->debug("storing $_  value: $sub_v");
                $node->fetch_element($_)->store( value => $sub_v, check => $check );
            }
        }
    }

    $node->fetch_element('diff')->store(join('',@$diff));

    return 1;
}

sub write {
    my $self = shift;
    my %args = @_;

    # args is:
    # object     => $obj,         # Config::Model::Node object
    # root       => './my_test',  # fake root directory, userd for tests
    # config_dir => /etc/foo',    # absolute path
    # file       => 'foo.conf',   # file name
    # file_path  => './my_test/etc/foo/foo.conf'
    # io_handle  => $io           # IO::File object

    # io_handle is not defined as no file is specified in model

    my $patch_dir = $args{root} . $args{config_dir};
    my $check     = $args{check};
    my $node      = $args{object};

    my $patch_name = $node->index_value;

    my $patch_file = "$patch_dir/$patch_name";
    $logger->info("Writing patch $patch_file");
    my $io = IO::File->new($patch_file,'w')
      || Config::Model::Exception::Syntax->throw(
        message => "cannot write patch $patch_file" );

    foreach my $elt ( $node -> get_element_name ) {
        my $v = $node->fetch_element_value($elt) ;
        next unless defined $v and $v;
        
        if ($elt eq 'Synopsis') {
            my $long_description = $node->fetch_element_value('Description') ;
            $v .= "\n" . $long_description if $long_description ;
            $io->print("Description:");
            $self->write_dpkg_text($io,$v) ;
        }
        elsif ($elt eq 'Description') { } # done in Synopsis
        elsif ($elt eq 'diff' ) {
            $io->print($node->fetch_element_value('diff')) ;
        }
        else {
            $io->print("$elt:");
            $self->write_dpkg_text($io,$v) ;
        }

    }

    return 1;
}

1;

__END__

=head1 NAME

Config::Model::Backend::Debian::Dpkg::Patch - Read and write Debian Dpkg Patch information

=head1 VERSION

version 1.259

=head1 SYNOPSIS

No synopsis. This class is dedicated to configuration class C<Debian::Dpkg::Patch>

=head1 DESCRIPTION

This module is used directly by L<Config::Model> to read or write the
content of Debian C<Patch> file.

All C<Patch> files keyword are read in a case-insensitive manner.

=head1 CONSTRUCTOR

=head2 new ( node => $node_obj, name => 'Debian::Dpkg::Patch' ) ;

Inherited from L<Config::Model::Backend::Any>. The constructor will be
called by L<Config::Model::AutoRead>.

=head2 read ( io_handle => ... )

Of all parameters passed to this read call-back, only C<io_handle> is
used. This parameter must be L<IO::File> object already opened for
read. 

It can also be undef. In this case, C<read()> will return 0.

When a file is read,  C<read()> will return 1.

=head2 write ( io_handle => ... )

Of all parameters passed to this write call-back, only C<io_handle> is
used. This parameter must be L<IO::File> object already opened for
write. 

C<write()> will return 1.

=head1 AUTHOR

Dominique Dumont, (ddumont at cpan dot org)

=head1 SEE ALSO

L<Config::Model>, 
L<Config::Model::AutoRead>, 
L<Config::Model::Backend::Any>, 

=cut
