module git.sys.stream;

import git, git.sys;

import std.bitmanip : bitfields;
import core.sys.posix.sys.types : ssize_t;
import core.stdc.config : c_ulong;
alias size_t = c_ulong;

extern (C):

enum GIT_STREAM_VERSION = 1;

struct git_stream
{
    int version_;

    mixin(bitfields!(
        uint, "encrypted", 1,
        uint, "proxy_support", 1,
        uint, "", 6)
    );

    int timeout;
    int connect_timeout;
    int function(git_stream*) connect;
    int function(git_cert**, git_stream*) certificate;
    int function(git_stream*, const(git_proxy_options)* proxy_opts) set_proxy;
    ssize_t function(git_stream*, void*, size_t) read;
    ssize_t function(git_stream*, const(char)*, size_t, int) write;
    int function(git_stream*) close;
    void function(git_stream*) free;
}

struct git_stream_registration
{
    int version_;
    int function(git_stream** gs_out, const(char)* host, const(char)* port) init;
    int function(git_stream** gs_out, git_stream* gs_in, const(char)* host) wrap;
}

enum git_stream_t
{
    standard = 1,
    tls = 2
}

int git_stream_register(
    git_stream_t type,
    git_stream_registration* registration
);

alias git_stream_cb = int function(git_stream** gs_out, const(char)* host, const(char)* port);

int git_stream_register_tls(git_stream_cb ctor);
