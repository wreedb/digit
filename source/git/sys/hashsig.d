module git.sys.hashsig;

import core.stdc.config;
alias size_t = c_ulong;

import git, git.sys;

extern (C):

struct git_hashsig;

enum git_hashsig_option_t
{
    normal = 0,
    ignore_whitespace = (1 << 0),
    smart_whitespace = (1 << 1),
    allow_small_files = (1 << 2)
}

int git_hashsig_create(
    git_hashsig** hs_out,
    const(char)* buf,
    size_t buflen,
    git_hashsig_option_t opts
);

int git_hashsig_create_fromfile(
    git_hashsig** hs_out,
    const(char)* path,
    git_hashsig_option_t opts
);

void git_hashsig_free(git_hashsig* sig);
int git_hashsig_compare(const(git_hashsig)* a, const(git_hashsig)* b);