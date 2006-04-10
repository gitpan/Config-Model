# $Author: ddumont $
# $Date: 2006/04/10 11:39:27 $
# $Name:  $
# $Revision: 1.2 $

#    Copyright (c) 2005,2006 Dominique Dumont.
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

package Config::Model::Instance;
use Scalar::Util qw(weaken) ;
use Config::Model::Exception ;
use Config::Model::Node ;
use Config::Model::Loader;
use Config::Model::Searcher;

use strict ;
use Carp;
use warnings FATAL => qw(all);
use warnings::register ;

use vars qw/$VERSION/ ;

$VERSION = sprintf "%d.%03d", q$Revision: 1.2 $ =~ /(\d+)\.(\d+)/;

use Carp qw/croak confess cluck/;

=head1 NAME

Config::Model::Instance - Instance of configuration tree

=head1 SYNOPSIS

 my $model = Config::Model->new() ;
 $model ->create_config_class ( ... ) ;

 my $inst = $model->instance (root_class_name => 'SomeRootClass', 
                              instance_name    => 'some_name');

=head1 DESCRIPTION

This module provides an object that holds a configuration tree. 

=head1 CONSTRUCTOR

Usually, an instance object is created by calling 
L<instance method|Config::Model/"Configuration instance"> on 
an existing model:

 my $inst = $model->instance (root_class_name => 'SomeRootClass', 
                              instance_name => 'test1');

=cut

sub new {
    my $proto = shift ;
    my $class = ref($proto) || $proto ;
    my %args = @_ ;

    my $root_class_name = delete $args{root_class_name} || 
      confess __PACKAGE__," error: missing root_class_name parameter" ;

    my $config_model = delete $args{config_model} || 
      confess __PACKAGE__," error: missing config_model parameter" ;

    confess __PACKAGE__," error: config_model is not a Config::Model object"
      unless $config_model->isa('Config::Model') ; 

    my $self 
      = {
	 # stack used to store whether read and/or write check must 
	 # be done in tree objects (Value, Id ...)
	 check_stack => [ { fetch => 1,
			    store => 1,
			    type  => 1 } ],

	 # a unique (instance wise) placeholder for various tree objects
	 # to store informations
	 safe => {
		  auto_inc => {}
		 } ,
	 config_model => $config_model ,
	 name => $root_class_name ,

	 # This array holds a set of sub ref that will be invoked when
	 # the users requires to write all configuration tree in their
	 # backend storage.
	 write_back => [] ,
	};

    weaken($self->{config_model}) ;

    bless $self, $class;

    $self->{tree} = Config::Model::Node
      -> new ( config_class_name =>$root_class_name,
	       instance => $self,
	       config_model => $config_model
	     );

    return $self ;
}


=head1 METHODS

=head2 config_root()

Returns the root object of the configuration tree.

=cut

sub config_root {
    return shift->{tree} ;
}

=head2 config_model()

Returns the model of the configuration tree.

=cut

sub config_model {
    return shift->{config_model} ;
}


=head2 push_no_value_check ( [fetch] , [store], [type] )

Tune C<Config::Model::Value> to perform check on read (fetch) or write
(store).  The passed parameters are stacked. Parameters are :

=over 8

=item store

Skip write check.

=item fetch

Skip read check.

=item type

Skip value_type check (See L<Config::Model::Value> for details).

=back

Note that these values are stacked. They can be read by
get_value_check until the next push_no_value_check or
pop_no_value_check call.

=cut

sub push_no_value_check {
    my $self = shift ;
    my %h = ( fetch => 1, store => 1, type  => 1 ) ;

    foreach my $w (@_) {
        if (defined $h{$w}) {
            $h{$w} = 0;
	}
        else {
            croak "push_no_value_check: cannot relax $w value check";
	}
    }

    unshift @{ $self->{check_stack} }, \%h ;
}

=head2 pop_no_value_check()

Pop off the check stack the last check set entered with
C<push_no_value_check>.

=cut

sub pop_no_value_check {
    my $self = shift ;
    my $h = $self->{check_stack} ;

    if (@$h > 1) {
      # always leave the original value
        shift @$h ;
    }
    else {
        carp "pop_no_value_check: empty check stack";
    }
}

=head2 get_value_check ( fetch | store | type | fetch_or_store )

Read the check status. Returns 1 if a check is to be done. O if not. 
When used with the C<fetch_or_store> parameter, returns a logical C<or>
or the check values, i.e. C<read_check || write_check>

=cut

sub get_value_check {
    my $self = shift ;
    my $what = shift ;

    my $result =  $what eq 'fetch_or_store' 
      ? ($self->{check_stack}[0]{fetch} or $self->{check_stack}[0]{store})
        : $self->{check_stack}[0]{$what} ;

    croak "get_value_check: unexpected parameter: $what, ",
      "expected 'fetch', 'type', 'store', 'fetch_or_store'" 
        unless defined $result;

    return $result ;
}

=head2 data( kind, [data] )

The data method provide a way to store some arbitrary data in the
instance object.

=cut

sub data {
    my $self = shift;
    my $kind = shift || croak "undefined data kind";
    my $store = shift ;

    $self->{data}{$kind} = $store if defined $store;
    return $self->{data}{$kind} ;
}


=head2 load( "..." )

Load configuration tree with configuration data. See
L<Config::Model::Loader> for more details

=cut

sub load {
    my $self = shift ;
    my $loader = Config::Model::Loader->new ;
    $loader->load(node => $self->{tree}, @_) ;
}

=head2 search_element ( element => <name> [, privilege => ... ] )

Search an element in the configuration model (respecting privilege
level).

This method returns a L<Config::Model::Searcher> object. See
L<Config::Model::Searcher> for details on how to handle a search.

=cut

sub search_element {
    my $self = shift ;
    $self->{tree}->search_element(@_) ;
}

=begin comment

These function are used for model plugin which is not yet implemented

=head2 register_write_back ( sub_ref )

Register a sub ref that will be called with C<write_back> method.

=head2 write_back

Run all subroutines registered with C<register_write_back> to write
the configuration informations. (See L<Config::Model::AutoRead> for
details).

sub register_write_back {
    my $self = shift ;
    my $wb = shift;

    croak "register_write_back: parameter is not a code ref"
      unless ref($wb) eq 'CODE' ;
    push @{$self->{write_back}}, $wb ;
}

sub write_back {
    my $self = shift ;

    map { &$_ } @{$self->{write_back}} ;
}

=end comment

=cut

1;

=head1 AUTHOR

Dominique Dumont, domi@komarr.grenoble.hp.com

=head1 SEE ALSO

L<Config::Model>, 
L<Config::Model::Node>, 
L<Config::Model::Loader>,
L<Config::Model::Searcher>,
L<Config::Model::Value>,

=cut

