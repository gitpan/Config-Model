#
# This file is part of Config-Model
#
# This software is Copyright (c) 2015 by Dominique Dumont.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package Config::Model::Utils::GenClassPod;
$Config::Model::Utils::GenClassPod::VERSION = '2.065';
# ABSTRACT: generate pod documentation from configuration models

use strict;
use warnings;
use parent qw(Exporter);
our @EXPORT = qw(gen_class_pod);

use lib qw/lib/;
use Path::Tiny ;
use Config::Model ;             # to generate doc

sub gen_class_pod {
    my $cm = Config::Model -> new(model_dir => "lib/Config/Model/models") ;

    my @models = @_ ? @_ :
        map { /model\s*=\s*([\w:-]+)/; $1; }
        grep { /^\s*model/; }
        map  { $_->lines; }
        map  { $_->children; }
        path ("lib/Config/Model/")->children(qr/\.d$/);

    foreach my $model (@models) {
        # this test avoid generating doc several times (generate_doc scan docs for
        # classes referenced by the model with config_class_name parameter)
        if (not $cm->model_exists($model)) {
            print "Checking doc for model $model\n";
            $cm->load($model) ;
            $cm->generate_doc ($model,'lib') ;
        }
    }
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Config::Model::Utils::GenClassPod - generate pod documentation from configuration models

=head1 VERSION

version 2.065

=head1 SYNOPSIS

 use Config::Model::Utils::GenClassPod;
 gen_class_pod;

=head1 DESCRIPTION

This module provides a single exported function:
C<gen_class_pod>. This function will scan C<./lib/Config/Model/models>
and generate a pod documentation for each C<.pl> found there using
L<Config::Model::generate_doc|Config::Model/"generate_doc ( top_class_name , [ directory ] )">

=head1 AUTHOR

Dominique Dumont

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2015 by Dominique Dumont.

This is free software, licensed under:

  The GNU Lesser General Public License, Version 2.1, February 1999

=cut
