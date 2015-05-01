package App::Devel::Notebook::Worksheet;

use Moose;
use namespace::autoclean;

=head1 NAME


=head1 DESCRIPTION

Catalyst Model.


=encoding utf8

=cut

has 'cells' => (
    is => 'rw',
    isa => 'ArrayRef[App::Devel::Notebook::Cell]',
    reader => 'Cells',
    writer => '_Cells',
    default => sub {return [];}
);

=head1 AUTHOR

Pablo Rodríguez

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
