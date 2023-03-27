package HTTP::Client::Trace;
use 5.10.1;
use strict;
use warnings;

use Data::Dumper ();

our $VERSION = '0.001';

sub import {
    my $class = shift;
    trace_http_tiny();
    trace_http_tinyish_curl();
    trace_http_tinyish_wget();
    trace_lwp_useragent();
    trace_mojo_useragent();
}

sub dumper {
    my $dump = Data::Dumper
        ->new([])
        ->Trailingcomma(1)
        ->Terse(1)
        ->Indent(1)
        ->Useqq(1)
        ->Deparse(1)
        ->Quotekeys(0)
        ->Sortkeys(1)
        ->Values(\@_)
        ->Dump;
    warn $dump;
}

sub trace_http_tiny {
    my $class = shift;
    state $done;
    return if $done;
    $done++;

    eval { require HTTP::Tiny } or return;
    my $ID = 0;
    my $orig = HTTP::Tiny->can("request");
    my $new = sub {
        my ($self, $method, $url, $args) = @_;
        my $id = ++$ID;
        dumper { id => "HTTP::Tiny $id", request => { method => $method, url => $url, args => $args } };
        my $res = $self->$orig($method, $url, $args);
        dumper { id => "HTTP::Tiny $id", response => $res };
        $res;
    };
    no warnings qw(once redefine);
    *HTTP::Tiny::request = $new;
}

sub trace_lwp_useragent {
    my $class = shift;
    state $done;
    return if $done;
    $done++;

    eval { require LWP::UserAgent } or return;
    my $ID = 0;
    my $orig = LWP::UserAgent->can("send_request");
    my $new = sub {
        my ($self, $request, $arg, $size) = @_;
        my $id = ++$ID;
        dumper { id => "LWP::UserAgent $id", request => { request => $request, arg => $arg, size => $size } };
        my $res = $self->$orig($request, $arg, $size);
        dumper { id => "LWP::UserAgent $id", response => $res };
        $res;
    };
    no warnings qw(once redefine);
    *LWP::UserAgent::send_request = $new;
}

sub trace_mojo_useragent {
    my $class = shift;
    state $done;
    return if $done;
    $done++;

    eval { require Mojo::UserAgent } or return;
    my $ID = 0;
    my $orig = Mojo::UserAgent->can("new");
    my $new = sub {
        my $class = shift;
        my $self = $class->$orig(@_);
        $self->on(start => sub {
            my ($self, $tx) = @_;
            my $id = ++$ID;
            dumper { id => "Mojo::UserAgent $id", request => $tx->req };
            $tx->{__id} = $id;
            $tx->on(finish => sub {
                my $tx = shift;
                my $id = delete $tx->{__id};
                dumper { id => "Mojo::UserAgent $id", response => $tx->res };
            });
        });
        $self;
    };
    no warnings qw(once redefine);
    *Mojo::UserAgent::new = $new;
}

sub trace_http_tinyish_curl {
    my $class = shift;
    state $done;
    return if $done;
    $done++;

    eval { require HTTP::Tinyish::Curl } or return;
    my $ID = 0;
    my $orig = HTTP::Tinyish::Curl->can("request");
    my $new = sub {
        my($self, $method, $url, $opts) = @_;
        my $id = ++$ID;
        dumper { id => "HTTP::Tinyish::Curl $id", request => { method => $method, url => $url, opts => $opts } };
        my $res = $self->$orig($method, $url, $opts);
        dumper { id => "HTTP::Tinyish::Curl $id", response => $res };
        $res;
    };
    no warnings qw(once redefine);
    *HTTP::Tinyish::Curl::request = $new;
}

sub trace_http_tinyish_wget {
    my $class = shift;
    state $done;
    return if $done;
    $done++;

    eval { require HTTP::Tinyish::Wget } or return;
    my $ID = 0;
    my $orig = HTTP::Tinyish::Wget->can("request");
    my $new = sub {
        my($self, $method, $url, $opts) = @_;
        my $id = ++$ID;
        dumper { id => "HTTP::Tinyish::Wget $id", request => { method => $method, url => $url, opts => $opts } };
        my $res = $self->$orig($method, $url, $opts);
        dumper { id => "HTTP::Tinyish::Wget $id", response => $res };
        $res;
    };
    no warnings qw(once redefine);
    *HTTP::Tinyish::Wget::request = $new;
}

1;
__END__

=encoding utf-8

=head1 NAME

HTTP::Client::Trace - trace HTTP clients

=head1 SYNOPSIS

  ❯ perl -MHTTP::Client::Trace your-program

or

  ❯ PERL5OPT=-MHTTP::Client::Trace your-program

=head1 DESCRIPTION

HTTP::Client::Trace traces HTTP clients.
Currently the following HTTP clients are supported:

=over 4

=item L<HTTP::Tiny>

=item L<LWP::UserAgent>

=item L<Mojo::UserAgent>

=item L<HTTP::Tinyish>

=back

=head1 INSTALL

  ❯ cpm install -g https://github.com/skaji/HTTP-Client-Trace.git

=head1 COPYRIGHT AND LICENSE

Copyright 2023 Shoichi Kaji <skaji@cpan.org>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
