package App::Web::Notebook;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
/;

extends 'Catalyst';

with 'CatalystX::REPL';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in app_web_notebook.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'App::Web::Notebook',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
);

# Start the application
__PACKAGE__->setup();

=encoding utf8

=head1 NAME

App::Web::Notebook - Perl notebook-style web interface for explorative/illustrative programming

=head1 SYNOPSIS

    script/app_web_notebook_server.pl

=head1 DESCRIPTION

This is a L<Catalyst|http://www.catalystframework.org/> web app, that mimics notebook style interfaces. The first version uses 
L<Devel::REPL|https://metacpan.org/pod/Devel::REPL> as the backend. It uses L<CodeMirror|https://codemirror.net/> javascript library for nice perl code rendering on the browser and L<Dojo|http://dojotoolkit.org/> for a "RIA (Rich Internet Application)" (It's a wish more than a reality). 

Javascript libraries content delivery provided by: 

=over 4

=item L<cdnjs|https://cdnjs.com/>: CodeMirror

=item L<Google Hosted Libraries|https://developers.google.com/speed/libraries/>: Dojo

=back

=head1 SEE ALSO

L<Catalyst|http://www.catalystframework.org/>, L<Devel::REPL|https://metacpan.org/pod/Devel::REPL>, L<CodeMirror|https://codemirror.net/>, L<cdnjs|https://cdnjs.com/>

=head1 AUTHOR

Pablo Rodríguez González

=head1 LICENSE

This program is free software; you
can redistribute it and/or modify it under the terms of the
Artistic License 2.0. For details, see the full text of the
license in the file LICENSE.

=cut

1;
