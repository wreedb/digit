module git.oidarray;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

struct git_oidarray
{
    git_oid* ids;
    size_t count;
}

void git_oidarray_dispose(git_oidarray* array);