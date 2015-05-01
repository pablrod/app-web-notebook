package App::Devel::Notebook;

use Moose;
use Devel::REPL;
use App::Devel::Notebook::Cell;
use App::Devel::Notebook::Worksheet;
use Params::Validate qw(:all);
use Data::Dumper;
use namespace::autoclean;

=encoding utf8

=head1 NAME

App::Devel::Notebook - Notebook object for collecting and anotating code and results

=head1 DESCRIPTION

=cut

has 'worksheets' => ( is      => 'rw',
                      isa     => 'ArrayRef[App::Devel::Notebook::Worksheet]',
                      reader  => 'Worksheets',
                      writer  => '_Worksheets',
                      default => sub { return [] }
);

has 'id' => ( is     => 'ro',
              isa    => 'Str',
              reader => 'Id'
);

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

=head1 METHODS

=cut

=head2 Execute

Execute and save notebook code

=cut

sub Execute {
    my $self      = shift;
    my $worksheet = shift;
    my $cell      = shift;
    my $code      = shift;
    $self->CellCode( worksheet => $worksheet - 1, cell => $cell - 1, code => $code );
    my @ret = $self->repl->formatted_eval($code);
    $self->CellResult( worksheet => $worksheet - 1, cell => $cell - 1, result => join( '', @ret ) );
    return @ret;
}

=head2 CellCode

Change de code for a given cell

=cut

sub CellCode {
    my $self = shift;
    my %params =
      validate( @_, { worksheet => { type => SCALAR }, cell => { type => SCALAR }, code => { type => SCALAR } } );
    my $worksheets           = $self->Worksheets();
    my $number_of_worksheets = scalar @$worksheets;
    if ( $number_of_worksheets <= $params{'worksheet'} ) {
        if ( $params{'worksheet'} - $number_of_worksheets >= 1 ) {
            for ( 0 .. ( $params{'worksheet'} - $number_of_worksheets - 1 ) ) {
                my $cells = [ App::Devel::Notebook::Cell->new() ];
                push @$worksheets, App::Devel::Notebook::Worksheet->new( cells => $cells );
            }
        }
        my $cells = [ App::Devel::Notebook::Cell->new( code => $params{'code'} ) ];
        push @$worksheets, App::Devel::Notebook::Worksheet->new( cells => $cells );
    } else {
        my $cells           = $worksheets->[ $params{'worksheet'} ]->Cells();
        my $number_of_cells = scalar @$cells;
        if ( $number_of_cells <= $params{'cell'} ) {
            push @$cells, App::Devel::Notebook::Cell->new( code => $params{'code'} );
        } else {
            $cells->[ $params{'cell'} ]->_Code( $params{'code'} );
        }
    }
}

=head2 CellResult

Change de result for a given cell

=cut

sub CellResult {
    my $self = shift;
    my %params = validate( @_,
                           {  worksheet => { type => SCALAR },
                              cell      => { type => SCALAR },
                              result    => { type => SCALAR }
                           }
    );
    my $worksheets = $self->Worksheets();
    $worksheets->[ $params{'worksheet'} ]->Cells()->[ $params{'cell'} ]->_Result( $params{'result'} );
}

sub Dump {
    my $self       = shift;
    my %hash_dump  = ( id => $self->Id() );
    my $worksheets = [];
    for my $worksheet ( @{ $self->Worksheets } ) {
        my $cells = [];
        for my $cell ( @{ $worksheet->Cells } ) {
            push @$cells, { code => $cell->Code, result => $cell->Result };
        }
        push @$worksheets, $cells;
    }
    $hash_dump{'worksheets'} = $worksheets;
    return Dumper( \%hash_dump );
}

sub FromDump {
    my $class = shift;
    my $dump  = shift;
    my $VAR1;
    eval $dump;
    if ( !$@ ) {
        my $worksheets = [];
        for my $worksheet ( @{ $VAR1->{'worksheets'} } ) {
            my $cells = [];
            for my $cell (@{$worksheet}) {
                push @$cells,
                  App::Devel::Notebook::Cell->new( code   => $cell->{'code'},
                                                   result => $cell->{'result'} );
            }
            push @$worksheets, App::Devel::Notebook::Worksheet->new(cells => $cells);
        }
        return __PACKAGE__->new( id => $VAR1->{'id'}, worksheets => $worksheets );
    } else {
        return undef;
    }
}

=head1 AUTHOR

Pablo Rodríguez González

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
