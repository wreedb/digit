module git.apply;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

alias git_apply_delta_cb = int function(
    const(git_diff_delta)* delta,
    void* payload
);

alias git_apply_hunk_cb = int function(
    const(git_diff_hunk)* hunk,
    void* payload
);

enum git_apply_flags_t
{
    CHECK = 1 << 0
}

struct git_apply_options
{
    uint version_;
    git_apply_delta_cb delta_cb;
    git_apply_hunk_cb hunk_cb;
    void* payload;
    uint flags;
}

enum GIT_APPLY_OPTIONS_VERSION = 1;

int git_apply_options_init(git_apply_options* opts, uint vers);

int git_apply_to_tree(
    git_index** index_out,
    git_repository* repo,
    git_tree* preimage,
    git_diff* diff,
    const(git_apply_options)* options
);

enum git_apply_location_t
{
    WORKDIR = 0,
    INDEX = 1,
    BOTH = 2
}

int git_apply(
    git_repository* repo,
    git_diff* diff,
    git_apply_location_t location,
    const(git_apply_options)* options
);
