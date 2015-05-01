package App::Web::Notebook::View::Notebook;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

App::Web::Notebook::View::Notebook - TT View for App::Web::Notebook

=head1 DESCRIPTION

TT View for App::Web::Notebook.

=head1 SEE ALSO

L<App::Web::Notebook>

=head1 AUTHOR

Pablo Rodríguez

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
