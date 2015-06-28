package App::Devel::Notebook::Engine::Cling;

use Moose;
use IPC::Run qw( start pump finish timeout );
use namespace::autoclean;

=encoding utf8

=head1 NAME

App::Devel::Notebook::Engine::DevelREPL - Cling Engine

=head1 DESCRIPTION


=cut

with 'App::Devel::Notebook::Engine';

has 'command_number' => (
	is => 'rw',
	isa => 'Int',
	default => 0
);

my ($input, $output, $error);

has 'handler' => (
    is      => 'ro',
    isa     => 'IPC::Run',
    default => sub {
    	my $self = shift;
    	$self->input('');
    	$self->output('');
    	$self->error('');
    	my @command = qw(/usr/bin/root);
		my $handler = start \@command, \$input, '>pty>', \$output, '2>', \$error, timeout( 10 );
        return $handler;
    },
    lazy => 1
);

sub Execute {
	my $self = shift;
	return $self->_ExecuteMarked(shift);
}

sub _ExecuteMarked {
	my $self = shift;
	my $marker_string_begin = "Marker-begin-" . $self->command_number();
	my $marker_string_end = "Marker-end-" . $self->command_number();
	$self->command_number($self->command_number + 1);
	$output = '';
	$input .= $self->_WrapCommandWithMarkerString(shift, $marker_string_begin, $marker_string_end);
	pump $self->handler until $output =~ /$marker_string_end/g;
	my $salida = $output;
	my @salida = split /$marker_string_begin|$marker_string_end/, $salida;
	return $salida[-2];
}

sub _WrapCommandWithMarkerString {
	my $self = shift;
	my $command = shift;
	my $marker_string_begin = shift;
	my $marker_string_end = shift;
	return "#include <iostream>\nstd::cout << ".'"' . $marker_string_begin . '"' . " << std::endl;\n" . 
		 $command . "\n#include <iostream>\nstd::cout << ".'"' . $marker_string_end . '"' . " << std::endl;\n";
}

sub DEMOLISH {
	my $self = shift;
	finish $self->handler;
}

=head1 AUTHOR

Pablo Rodríguez González

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
