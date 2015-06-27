package App::Devel::Notebook::Manager;

use Moose;
use namespace::autoclean;
use 5.016002;
use Path::Tiny;
use Data::UUID;
use utf8;
use App::Devel::Notebook;

=encoding utf8

=head1 NAME

App::Devel::Notebook::Manager - Manager for loading, saving, creating and deleting notebooks

=head1 DESCRIPTION

=cut

has 'notebooks' => ( is      => 'rw',
                     isa     => 'HashRef[App::Devel::Notebook]',
                     writer  => '_Notebooks',
                     reader  => 'Notebooks',
                     default => sub { return {}; }
);

has 'savepath' => ( is => 'rw',
					isa => 'Str',
					writer => '_SavePath',
					reader => 'SavePath',
					default => '~/.perlnotebooks'
);

=head1 METHODS

=cut

# On Build load existing notebooks
sub BUILD {
    my $self = shift;
    path($self->SavePath())->mkpath;
    my @files     = path($self->SavePath())->children;
    my $notebooks = {};
    for my $file (@files) {
        my $notebook = App::Devel::Notebook->FromDump( $file->slurp_raw );
        $notebooks->{ $notebook->Id() } = $notebook;
    }
    if ( scalar keys %$notebooks == 0 ) {
        $self->Add;
    } else {
        $self->_Notebooks($notebooks);
    }
    return ();
}

# On Demolis auto-save existing notebooks
sub DEMOLISH {
    my $self      = shift;
    my $notebooks = $self->Notebooks;
    for my $notebook ( values %$notebooks ) {
        $self->Save;
    }
    return ();
}

=head2 Add

Add a new notebook

=cut

sub Add {
    my $self      = shift;
    my $notebooks = $self->Notebooks;
    $self->_Add($notebooks);
    return ();
}

sub _Add {
    my $self           = shift;
    my $notebooks      = shift;
    my $uuid_generator = Data::UUID->new;
    my $id             = $uuid_generator->create_from_name_str( $uuid_generator->create_str(), 'Notebook' );
    $notebooks->{$id} = App::Devel::Notebook->new( id => $id );
    return ();
}

sub Notebook {
    my $self        = shift;
    my $notebook_id = shift;
    my $notebooks   = $self->Notebooks;
    if ( defined $notebook_id ) {
        return $notebooks->{$notebook_id};
    } else {
        my @notebooks = values %$notebooks;
        return $notebooks[0];
    }
}

=head2 Delete

Delete a notebook

=cut

sub Delete {
    my $self        = shift;
    my $notebook_id = shift;
    my $notebooks   = $self->Notebooks;
    delete $notebooks->{$notebook_id};
    path($self->SavePath())->child($notebook_id)->remove;
    return ();
}

sub SaveById {
    my $self = shift;
    my $notebook_id = shift;
    my $notebook = $self->Notebooks()->{$notebook_id};
    $self->Save($notebook);
}

sub Save {
    my $self     = shift;
    my $notebook = shift;
    my $path     = path($self->SavePath());
    my $file     = $path->child( $notebook->Id() );
    $file->spew_raw( $notebook->Dump() );
}

=head1 SEE ALSO

=head1 AUTHOR

Pablo Rodríguez González

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
