# $Author: ddumont $
# $Date: 2007/01/08 12:48:23 $
# $Name:  $
# $Revision: 1.7 $

#    Copyright (c) 2005-2007 Dominique Dumont.
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

package Config::Model::WarpedNode ;

use Carp qw(cluck croak);
use strict;
use Scalar::Util qw(weaken) ;

use base qw/Config::Model::WarpedThing/ ;
use Config::Model::Exception ;
use Data::Dumper ;

use vars qw($VERSION $AUTOLOAD) ;
$VERSION = sprintf "%d.%03d", q$Revision: 1.7 $ =~ /(\d+)\.(\d+)/;

=head1 NAME

Config::Model::WarpedNode - Node that change config class properties 

=head1 SYNOPSIS

 $model ->create_config_class 
  (
   name => 'Class_with_one_changing_node',
   element =>
   [
    tree_macro => {type => 'leaf',
                   value_type => 'enum',
                   choice     => [qw/XY XZ mXY W/]
                  },

    'a_warped_node'
    => {
        type => 'warped_node',
        follow  => '! tree_macro',
        morph   => 1,
        rules => {
                  XY  => { config_class_name => ['SlaveY'], },
                  mXY => {
                          config_class_name   => 'SlaveY',
                          permission => 'intermediate'
                         },
                  XZ => { config_class_name => 'SlaveZ' }
                 }
       },

=head1 DESCRIPTION

This class provides a way to change dynamically the configuration
class (or some other properties) of a node. The changes are done
according to the model declaration. 

This declaration will specify one (or several) leaf in the
configuration tree that will trigger the actual property change of the
warped node. This leaf is also refered as I<warp master>.

When the warp master(s) value(s) changes, WarpedNode will create an instance
of the new class required by the warp master. 

If the morph parameter is set, the values held by the old object are
(if possible) copied to the new instance of the object using
L<copy_from|Config::Model::Node/"copy_from ( another_node_object )">
method.

Warped node can alter the following properties:

 config_class_name
 permission
 level

=head1 Constructor

WarpedNode should not be created directly.

=head1 Warped node model declaration

=head2 Parameter overview

A warped node must be declared with the following parameters:

=over

=item type

Always set to C<warped_node>.

=item follow

L<Grab string|Config::Model::AnyThing/"grab(...)"> leading to the
C<Config::Model::Value> warp master.
See L<Config::Model::WarpedThing/"Warp follow argument"> for details.

=item morph

boolean. If 1, WarpedNode will try to recursively copy the value from
the old object to the new object using 
<copy_from method|L<Config::Model::Node/"copy_from ( another_node_object )">.
When a copy is not possible, undef values
will be assigned to object elements.

=item rules

Hash or array ref that specify the property change rules according to the
warp master(s) value(s). 
See L<Config::Model::WarpedThing/"Warp rules argument"> for details 
on how to specify the warp master values (or combination of values).

=back

=head2 Effect declaration

For a warped node, the effects are declared with these parameters:

=over 8

=item B<config_class_name>

When requested by the warp master,the WarpedNode will create a new
object of the type specified by this parameter:

  XZ => { config_class_name => 'SlaveZ' }

If you pass an array ref, the array will contain the class name and
constructor arguments :

  XY  => { config_class_name => ['SlaveY', foo => 'bar' ], },

=item B<permission>

Switch the permission of the slot when the object is warped in.

=back

=cut

# don't authorize to warp 'morph' parameter as it may lead to
# difficult maintenance

# status is not warpable either as an obsolete parameter must stay
# obsolete

my @allowed_warp_params = qw/config_class_name permission level/ ;

sub new {
    my $type = shift;
    my $self={} ;
    my %args = @_ ;

    bless $self,$type;

    my @mandatory_parameters = qw/element_name instance/;
    foreach my $p (@mandatory_parameters) {
	$self->{$p} = delete $args{$p} or
	  croak "WarpedNode->new: Missing $p parameter" ;
    }

    $self->_set_parent(delete $args{parent}) ;


    # optional parameter that makes sense only if warped node is held
    # by a hash or an array
    $self->{index_value}  =  delete $args{index_value} ;

    $self->{backup} = \%args ;

    # WarpedNode will register this object in a Value object (the
    # warper).  When the warper gets a new value, it will modify the
    # WarpedNode according to the data passed by the user.

    $self->check_warp_args(\@allowed_warp_params, \%args ) ;

    $self->set() ;

    $self->submit_to_warp($self->{warp}) if $self->{warp} ;

    $self->warp 
      if ($self->{warp} and @{$self->{warp_info}{computed_master}});

    return $self ;
}

sub name {
    my $self = shift;
    return $self->location($self) ;
}

# Forward selected methods (See man perltootc)
foreach my $method (qw/fetch_element config_class_name get_element_name
                       has_element is_element_available element_type load
		       fetch_element_value get_type get_cargo_type 
                       describe config_model/
		   ) {
    # to register new methods in package
    no strict "refs"; 

    *$method = sub {
	my $self= shift;
	$self->check ;
	return $self->{data}->$method(@_);
    } ;
}

sub get_actual_node {
    my $self= shift;
    $self->check ;
    return $self->{data} ;
}

sub check {
    my $self= shift;

    # must croak if element is not available
    Config::Model::Exception::User->throw
	(
	 object => $self,
	 message => "Object '$self->{element_name}' is not accessible.\n\t".
	 $self->warp_error
	) unless defined $self->{data};
}

sub set {
    my $self = shift ;

    my %args = (%{$self->{backup}},@_) ;

    # mega cleanup
    map(delete $self->{$_}, @allowed_warp_params) ;

    print $self->name." set called with \n", Dumper(\%args)
      if $::debug ;

    $self->set_parent_element_property(\%args) ;

    my $config_class_name = $args{config_class_name};
    return unless defined $config_class_name ;

    my @args ;
    ($config_class_name,@args) = @$config_class_name 
      if ref $config_class_name ;

    # check if some action is needed (ie. create or morph node)
    return if defined $self->{config_class_name} 
      and $self->{config_class_name} eq $config_class_name ;

    my $old_object = $self->{data} ;
    my $morph = $self->{warp}{morph} ;

    # create a new object from scratch
    my $new_object = $self->create_node($config_class_name,@args) ;

    if (defined $old_object and $morph) {
        # there an old object that we need to translate
        print "morphing ",$old_object->name," to ",$new_object->name,"\n"
          if $::debug ;

        $new_object->copy_from($old_object) ;
    }

    $self->{config_class_name} = $config_class_name ;
    $self->{data} = $new_object ;
}

sub create_node {
    my $self= shift ;
    my $config_class_name = shift ;
    my @init_step = @_ ;

    my @args = (config_class_name => $config_class_name,
		instance          => $self->{instance},
		element_name      => $self->{element_name},
		index_value       => $self->{index_value},
	       ) ;

    push @args, init_step => \@init_step if @init_step ;

    return  $self->parent->new(@args) ;
}


1;

__END__

=head1 EXAMPLE


 $model ->create_config_class 
  (
   permission => [ bar => 'advanced'] ,
   element =>
    [
     tree_macro => { type => 'leaf',
                     value_type => 'enum',
                     choice     => [qw/XX XY XZ ZZ/]
                   },
     bar =>  {
               type => 'warped_node',
               follow => '! tree_macro', 
               morph => 1,
               rules => [
                         XX => { config_class_name 
                                   => [ 'ClassX', 'foo' ,'bar' ]}
                         XY => { config_class_name => 'ClassY'},
                         XZ => { config_class_name => 'ClassZ'}
                        ]
             }
    ]
  );

In the example above we see that:

=over

=item *

The 'bar' slot can refer to a ClassX, ClassZ or ClassY object.

=item *

The warper object is the C<tree_macro> attribute of the root of the
object tree.

=item *

When C<tree_macro> is set to C<ZZ>, C<bar> will not be available. Trying to
access bar will raise an exception.

=item *

When C<tree_macro> is changed from C<ZZ> to C<XX>, 
C<bar> will refer to a brand new ClassX 
object constructed with C<< ClassX->new(foo => 'bar') >>

=item *

Then, if C<tree_macro> is changed from C<XX> to C<XY>, C<bar> will
refer to a brand new ClassY object. But in this case, the object will be
initialized with most if not all the attributes of ClassX. This copy
will be done whenever C<tree_macro> is changed.

=back

=head1 AUTHOR

Dominique Dumont, (ddumont at cpan dot org)

=head1 SEE ALSO

L<Config::Model::Instance>, 
L<Config::Model::Model>, 
L<Config::Model::HashId>,
L<Config::Model::ListId>,
L<Config::Model::AnyThing>,
L<Config::Model::WarpedThing>,
L<Config::Model::WarpedNode>,
L<Config::Model::Value>

=cut

