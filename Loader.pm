# $Author: ddumont $
# $Date: 2007/04/27 15:14:15 $
# $Name:  $
# $Revision: 1.12 $

#    Copyright (c) 2006-2007 Dominique Dumont.
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

package Config::Model::Loader;
use Carp;
use strict;
use warnings ;

use Config::Model::Exception ;

use vars qw($VERSION);
$VERSION = sprintf "%d.%03d", q$Revision: 1.12 $ =~ /(\d+)\.(\d+)/;

=head1 NAME

Config::Model::Loader - Load serialized data into config tree

=head1 SYNOPSIS

 use Config::Model ;

 # create your config model
 my $model = Config::Model -> new ;
 $model->create_config_class( ... ) ;

 # create instance
 my $inst = $model->instance (root_class_name => 'FooBar', 
			      instance_name => 'test1');

 # create root of config
 my $root = $inst -> config_root ;

 # put some data in config tree
 my $step = 'std_id:ab X=Bv - std_id:bc X=Av - a_string="toto tata"';
 $root->load( step => $step ) ;

=head1 DESCRIPTION

This module is used directly by L<Config::Model::Node> to load
serialized configuration data into the configuration tree.

Serialized data can be written by the user or produced by
L<Config::Model::Dumper> while dumping data from a configuration tree.

=head1 CONSTRUCTOR

=head2 new ( )

No parameter. The constructor should be used only by
L<Config::Model::Node>.

=cut

## load stuff, similar to grab, but used to set items in the tree
## staring from this node

sub new {
    bless {}, shift ;
}

=head1 load string syntax

The string is made of the following items separated by spaces:

=over 8

=item -

Go up one node

=item !

Go to the root node of the configuration tree.

=item xxx

Go down using C<xxx> element. (For C<node> type element)

=item xxx:yy

Go down using C<xxx> element and id C<yy> (For C<hash> or C<list>
element with C<node> cargo_type)

=item xxx~yy

Delete item referenced by C<xxx> element and id C<yy>

=item xxx=zz

Set element C<xxx> to value C<yy>. load also accepts to set elements
with a quoted string. (For C<leaf> element)

For instance C<foo="a quoted string">. Note that you cannot embed
double quote in this string. I.e C<foo="a \"quoted\" string"> will
fail.

=item xxx=z1,z2,z3

Set list element C<xxx> to list C<z1,z2,z3>.

=item xxx:yy=zz

For C<hash> element containing C<leaf> cargo_type. Set the leaf
identified by key C<yy> to value C<zz>.

=back

=head1 Methods

=head2 load ( ... )

Load data into the node tree (from the node passed with C<node>)
and fill values as we go following the instructions passed with
C<step>.  (C<step> can also be an array ref).

Parameters are:

=over

=item node

node ref of the root of the tree (of sub-root) to start the load from.

=item step

A string or an array ref containing the steps to load. See above for a
description of the string.

=item permission

Specify the permission level used during the load (default:
C<master>). The permission can be C<intermediate advanced master>.
The load will raise an exception if the step of the load string tries
to access an element with permission higher than user's permission.

=back

=cut

sub load {
    my $self = shift ;

    my %args = @_ ;

    my $node = delete $args{node} ;

    croak "load error: missing 'node' parameter" unless defined $node ;

    my $step = delete $args{step} ;
    croak "load error: missing 'step' parameter" unless defined $step ;

    my $permission = delete $args{permission} || 'master' ;
    my $inst = $node->instance ;

    # tune value checking
    my $tune_check 
      = defined $args{check_store} 
	and $args{check_store} == 0 ? 1 : 0 ;
    $inst->push_no_value_check('store') if $tune_check ;

    # accept commands
    my $huge_string = ref $step ? join( ' ', @$step) : $step ;

    # do a split on ' ' but take quoted string into account
    my @command = 
      ( 
       $huge_string =~ 
       m/
         (         # begin of *one* command
          (?:        # group parts of a command (e.g ...:...=... )
           [^\s"]+  # match anything but a space and a quote
           (?:        # begin quoted group 
             "         # begin of a string
              (?:        # begin group
                \\"       # match an escaped quote
                |         # or
                [^"]      # anything but a quote
              )*         # lots of time
             "         # end of the string
           )          # end of quoted group
           ?          # match if I got more than one group
          )+      # can have several parts in one command
         )        # end of *one* command
        /gx       # 'g' means that all commands are fed into @command array
       ) ; #"asdf ;

    #print "command is ",join('+',@command),"\n" ;

    my $ret=1 ;
    $ret = $self->_load($node, $permission, \@command) ;

    if (@command) {
        my $str = "Error: command '@command' was not executed, you may have".
          " specified too many '-' in your command\n" ;
        Config::Model::Exception::Load
	    -> throw (
		      error => $str,
		      object => $node
		     ) if $node->instance->get_value_check('store') ;
    }

    # restore default value checks
    $inst->pop_no_value_check  if $tune_check ;

    return $ret ;
}

my %load_dispatch = (
		     node        => \&_walk_node,
		     warped_node => \&_walk_node,
		     hash        => \&_load_hash,
		     check_list  => \&_load_list,
		     list        => \&_load_list,
		     leaf        => \&_load_leaf,
		    ) ;

sub _load {
    my ($self, $node, $permission, $cmdref) = @_ ;

    my $inst = $node->instance ;

    my $cmd ;
    while ($cmd = shift @$cmdref) {
        print "_load:Executing cmd '$cmd' on node $node\n" if $::debug;
	my $saved_cmd = $cmd ;

        next if $cmd =~ /^\s*$/ ;

        if ($cmd eq '!') {
	    $node = $node -> root ;
	    next ;
	}

	if ($cmd eq '-') {
	    $node = $node -> parent || return 0 ;
	    next ;
	}

	$cmd =~ s!^(\w+)!! ; # grab the first keyword
	my $element_name = $1 ;

        unless (defined $element_name) {
	    Config::Model::Exception::Load
		-> throw (
			  command => $saved_cmd ,
			  error => 'Syntax error: cannot find '
			  .'element in command'
			 );
	}

        unless (defined $node) {
	    Config::Model::Exception::Load
		-> throw (
			  command => $saved_cmd ,
			  error => "Error: Got undefined node"
			 );
	}

        unless (   $node->isa("Config::Model::Node") 
		or $node->isa("Config::Model::WarpedNode")) {
	    Config::Model::Exception::Load
		-> throw (
			  command => $saved_cmd ,
			  error => "Error: Expected a node (even a warped node), got '"
			  .$node -> name. "'"
			 );
	    # below, has_element method from WarpedNode will raise
	    # exception if warped_node is not available
	}

        unless ($node->has_element($element_name)) {
            Config::Model::Exception::UnknownElement
		-> throw (
			  object => $node,
			  element => $element_name,
			 ) if $inst->get_value_check('store');
            unshift @$cmdref,$saved_cmd ;
            return 0 ;
	}

        unless ($node->is_element_available(name => $element_name,
					    permission => 'master')) {
	    Config::Model::Exception::UnavailableElement
		-> throw (
			  object => $node,
			  element => $element_name
			 ) if $inst->get_value_check('fetch_or_store') ;
            unshift @$cmdref,$saved_cmd ;
            return 0;
	}

        unless ($node->is_element_available(name => $element_name, 
					    permission => $permission)) {
            Config::Model::Exception::RestrictedElement
		-> throw (
			  object => $node,
			  element => $element_name,
			  level => $permission,
			 ) if $inst->get_value_check('fetch_or_store');
            unshift @$cmdref,$saved_cmd ;
            return 0 ;
	}

	my $element_type = $node -> element_type($element_name) ;

	my $method = $load_dispatch{$element_type} ;

	croak "_load: unexpected element type '$element_type' for $element_name"
	  unless defined $method ;

	$node = $self->$method($node,$element_name,$cmd) ;

	return 0 unless defined $node ;
    }

    return 1 ;
}


sub _walk_node {
    my ($self,$node,$element_name,$cmd) = @_ ;

    my $element = $node -> fetch_element($element_name) ;

    unless ($cmd =~ /^\s*$/) {
	Config::Model::Exception::Load
	    -> throw (
		      command => $cmd,
		      error => "Don't know what to do with '$cmd' ".
		      "for node element" . $element -> element_name
		     ) ;
    }

    print "Opening node element ", $element->name, "\n"
      if $::verbose ;

    return $element;
}

sub _load_list {
    my ($self,$node,$element_name,$cmd) = @_ ;

    my $element = $node -> fetch_element($element_name) ;
    my $action = substr ($cmd,0,1,'') ;

    my $elt_type   = $node -> element_type( $element_name ) ;
    my $cargo_type = $element->cargo_type ;

    if ($action eq '=' and $cargo_type eq 'leaf') {
	# valid for check_list or list
	print "Setting $elt_type element ",$element->name," to $cmd\n"
	    if $::verbose ;
	my @set = split( /,/ , $cmd ) ;
	map { s/^"// ; s/"$//; } @set ;
	$element->store_set( @set ) ;
	return $node;
    }
    elsif ($elt_type eq 'list' and $action eq ':' and $cargo_type =~ /node/) {
	# remove possible leading or trailing quote
	$cmd =~ s/^"//;
	$cmd =~ s/"$//;
	return $element->fetch_with_id($cmd) ;
    }
    elsif ($elt_type eq 'list' and $action eq ':' and $cargo_type =~ /leaf/) {
	my ($id,$value) = ($cmd =~ m/(\w+)=(.*)/) ;
	$value =~ s/^"// ; # remove possible leading quote
	$value =~ s/"$// ; # remove possible trailing quote
	$element->fetch_with_id($id)->store($value) ;
	return $node ;
    }
    else {
	Config::Model::Exception::Load
	    -> throw (
		      object => $element,
                      command => $cmd ,
		      error => "Wrong assignment with '$action$cmd' on "
		      ."element type: $elt_type, cargo_type: $cargo_type"
		     ) ;
    }
}

sub _load_hash {
    my ($self,$node,$element_name,$cmd) = @_ ;

    my $element = $node -> fetch_element($element_name) ;
    my $action = substr ($cmd,0,1,'') ;

    my $cargo_type = $element->cargo_type ;

    if ($action eq ':' and $cargo_type =~ /node/) {
	# remove possible leading or trailing quote
	$cmd =~ s/^"//;
	$cmd =~ s/"$//;
	return $element->fetch_with_id($cmd) ;
    }
    elsif ($action eq ':' and $cargo_type =~ /leaf/) {
	# remove possible leading or trailing quote with the map
	my ($id,$value) = map  { s/^"// ;  s/"$// ; $_ } split /=/, $cmd, 2;
	#print "_load_hash: id is '$id', value is '$value' ($cmd)\n";
	$element->fetch_with_id($id)->store($value) ;
	return $node
    }
    else {
	Config::Model::Exception::Load
	    -> throw (
		      object => $element,
                      command => $cmd ,
		      error => "Hash assignment with $action$cmd on unexpected "
		      ."cargo_type: $cargo_type"
		     ) ;
    }
}

sub _load_leaf {
    my ($self,$node,$element_name,$cmd) = @_ ;

    my $element = $node -> fetch_element($element_name) ;
    my $action = substr ($cmd,0,1,'') ;

    if ($action eq '=' and $element->isa('Config::Model::Value')) {
	my $value = $cmd;
	$value =~ s/^"// ; # remove possible leading quote
	$value =~ s/"$// ; # remove possible trailing quote
	$element->store($value) ;
    }
    else {
	Config::Model::Exception::Load
	    -> throw (
		      object => $element,
                      command => $cmd ,
		      error => "Load error on leaf with "
		      ."'$element_name$action$cmd' command "
		      ."(element '".$element->name."')"
		     ) ;
    }

    return $node ;
}


1;

=head1 AUTHOR

Dominique Dumont, (ddumont at cpan dot org)

=head1 SEE ALSO

L<Config::Model>,L<Config::Model::Node>,L<Config::Model::Dumper>

=cut
