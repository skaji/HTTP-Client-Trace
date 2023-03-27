[![Actions Status](https://github.com/skaji/HTTP-Client-Trace/actions/workflows/test.yml/badge.svg)](https://github.com/skaji/HTTP-Client-Trace/actions)

# NAME

HTTP::Client::Trace - trace HTTP clients

# SYNOPSIS

    ❯ perl -MHTTP::Client::Trace your-program

or

    ❯ PERL5OPT=-MHTTP::Client::Trace your-program

# DESCRIPTION

HTTP::Client::Trace traces HTTP clients.
Currently the following HTTP clients are supported:

- [HTTP::Tiny](https://metacpan.org/pod/HTTP%3A%3ATiny)
- [LWP::UserAgent](https://metacpan.org/pod/LWP%3A%3AUserAgent)
- [Mojo::UserAgent](https://metacpan.org/pod/Mojo%3A%3AUserAgent)
- [HTTP::Tinyish](https://metacpan.org/pod/HTTP%3A%3ATinyish)

# INSTALL

    ❯ cpm install -g https://github.com/skaji/HTTP-Client-Trace.git

# COPYRIGHT AND LICENSE

Copyright 2023 Shoichi Kaji <skaji@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
