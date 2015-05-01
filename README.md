# NAME

App::Web::Notebook - Perl notebook-style web interface for explorative/illustrative programming

# SYNOPSIS

    script/app_web_notebook_server.pl

# DESCRIPTION

This is a [Catalyst](http://www.catalystframework.org/) web app, that mimics notebook style interfaces. The first version uses 
[Devel::REPL](https://metacpan.org/pod/Devel::REPL) as the backend. It uses [CodeMirror](https://codemirror.net/) javascript library for nice perl code rendering on the browser and [Dojo](http://dojotoolkit.org/) for a "RIA (Rich Internet Application)" (It's a wish more than a reality). 

Javascript libraries content delivery provided by: 

- [cdnjs](https://cdnjs.com/): CodeMirror
- [Google Hosted Libraries](https://developers.google.com/speed/libraries/): Dojo

    # SEE ALSO

    [Catalyst](http://www.catalystframework.org/), [Devel::REPL](https://metacpan.org/pod/Devel::REPL), [CodeMirror](https://codemirror.net/), [cdnjs](https://cdnjs.com/)

    # AUTHOR

    Pablo Rodríguez González

    # LICENSE

    This program is free software; you
    can redistribute it and/or modify it under the terms of the
    Artistic License 2.0. For details, see the full text of the
    license in the file LICENSE.
