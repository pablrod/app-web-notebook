package App::Web::Notebook::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

App::Web::Notebook::Controller::Root - Root Controller for App::Web::Notebook

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 notebook

Main notebook interface

=cut

sub notebook :Local {
    my ( $self, $c ) = @_;
    my $notebook_id = $c->req->body_params->{'notebook_id'} || $c->model('NotebookManager')->Notebook()->Id();
    $c->stash(cell_id => 1);
    $c->stash(notebook_id => $notebook_id);
    $c->stash->{current_view} = 'Notebook';
}

sub notebook_model : Local {
    my ($self, $c) = @_; 
    my $notebook_id = $c->req->body_params->{'notebook_id'};
    my $VAR1;
    my $dump = $c->model('NotebookManager')->Notebook($notebook_id)->Dump();
    eval $dump;
    if (!$@) {
     $c->stash(notebook => $VAR1);
     $c->stash->{current_view} = 'Notebook::API';
    }
}

=head2 execute_json 

add cell

=cut

sub execute_json :Local {
    my ( $self, $c ) = @_;
    my $code = $c->req->body_params->{'code'};
    my $notebook_id = $c->req->body_params->{'notebook_id'};
    my $cell = $c->req->body_params->{'cell_id'};

    $c->stash(result => join(" ", $c->model('NotebookManager')->Notebook($notebook_id)->Execute(1, $cell, $code)),
        cell_id => 1,
        code => $code);
    $c->stash->{current_view} = 'Notebook::API';
}

sub save :Local {
    my ( $self, $c ) = @_;
    my $notebook_id = $c->req->body_params->{'notebook_id'};
    $c->model('NotebookManager')->SaveById($notebook_id);
    $c->stash(status => 'Ok');
    $c->stash->{current_view} = 'Notebook::API';
}


=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Pablo Rodríguez González

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
