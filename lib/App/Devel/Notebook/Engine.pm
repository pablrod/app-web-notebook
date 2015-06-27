package App::Devel::Notebook::Engine;

use Moose::Role;

=encoding utf8

=head1 NAME

App::Devel::Notebook::Engine - Role for notebook engines

=head1 DESCRIPTION

Notebook engines for executing code from cells. Engines are the key component that
executes the code. This Role define the interface neccesary to allow the notebooks interact
with the engine.

The actual engine adaptors are located under the namespace App::Devel::Notebook::Engine:: 
as Moose::Pluggable objects

=cut

requires 'Execute';

=head1 AUTHOR

Pablo Rodríguez González

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
