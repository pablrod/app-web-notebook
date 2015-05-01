package App::Devel::Notebook::Cell;

use Moose;
use namespace::autoclean;

=head1 NAME


=head1 DESCRIPTION

Catalyst Model.

=encoding utf8

=cut

has 'code' => (
    is => 'rw',
    isa => 'Str',
    reader => 'Code',
    writer => '_Code',
    default => sub {return '';}
);

has 'result' => (
    is => 'rw',
    isa => 'Str',
    reader => 'Result',
    writer => '_Result',
    default => sub {return '';}
);

=head1 AUTHOR

Pablo Rodríguez González

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;


