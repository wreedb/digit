module git.buffer;

import core.stdc.config;

alias size_t = c_ulong;

extern (C):

struct git_buf
{
    char* ptr;
    size_t reserved;
    size_t size;
}

void git_buf_dispose(git_buf* buf);