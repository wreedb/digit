module git.stash;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

enum git_stash_flags
{
    normal = 0,
    keep_index = (1 << 0),
    include_untracked = (1 << 1),
    include_ignored = (1 << 2),
    keep_all = (1 << 3)
}

int git_stash_save(
    git_oid* oid_out,
    git_repository* repo,
    const(git_signature)* stasher,
    const(char)* message,
    uint flags
);

struct git_stash_save_options
{
    uint version_;
    uint flags;
    const(git_signature)* stasher;
    const(char)* message;
    git_strarray paths;
}

enum GIT_STASH_SAVE_OPTIONS_VERSION = 1;

int git_stash_save_options_init(git_stash_save_options* opts, uint version_);

int git_stash_save_with_opts(
    git_oid* oid_out,
    git_repository* repo,
    const(git_stash_save_options)* opts
);

enum git_stash_apply_flags
{
    normal = 0,
    reinstate_index = (1 << 0)
}

enum git_stash_apply_progress_t
{
    none = 0,
    loading_stash = 1,
    analyze_index = 2,
    analyze_modified = 3,
    analyze_untracked = 4,
    checkout_untracked = 5,
    checkout_modified = 6,
    done = 7
}

alias git_stash_apply_progress_cb = int function(
    git_stash_apply_progress_t progress,
    void* payload
);

struct git_stash_apply_options
{
    uint version_;
    uint flags;
    git_checkout_options checkout_options;
    git_stash_apply_progress_cb progress_cb;
    void* progress_payload;
}

enum GIT_STASH_APPLY_OPTIONS_VERSION = 1;

int git_stash_apply_options_init(git_stash_apply_options* opts, uint version_);

int git_stash_apply(
    git_repository* repo,
    size_t index,
    const(git_stash_apply_options)* options
);

alias git_stash_cb = int function(
    size_t index,
    const(char)* message,
    const(git_oid)* stash_id,
    void* payload
);

int git_stash_foreach(
    git_repository* repo,
    git_stash_cb callback,
    void* payload
);

int git_stash_drop(git_repository* repo, size_t index);

int git_stash_pop(
    git_repository* repo,
    size_t index,
    const(git_stash_apply_options)* options
);