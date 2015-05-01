use strict;
use warnings;

use App::Web::Notebook;

my $app = App::Web::Notebook->apply_default_middlewares(App::Web::Notebook->psgi_app);
$app;

