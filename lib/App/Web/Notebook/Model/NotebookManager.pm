package App::Web::Notebook::Model::NotebookManager;
use strict;
use warnings;
use base 'Catalyst::Model::Adaptor';

__PACKAGE__->config( 
    class       => 'App::Devel::Notebook::Manager',
    constructor => 'new',
);

1;
