package App::Devel::Notebook::Engine::Devel::REPL;

use Moose;
use Devel::REPL;
use namespace::autoclean;

=encoding utf8

=head1 NAME

App::Devel::Notebook::Engine::DevelREPL - Devel::REPL Engine

=head1 DESCRIPTION


=cut

with 'App::Devel::Notebook::Engine';

has 'repl' => (
    is      => 'ro',
    isa     => 'Devel::REPL',
    default => sub {
        my $repl = Devel::REPL->new;
        $repl->load_plugin($_) for qw(LexEnv);
        return $repl;
    },
    lazy => 1
);

sub Execute {
	my $self = shift;
	return $self->repl->formatted_eval(shift);	
}

=head1 AUTHOR

Pablo Rodríguez González

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
