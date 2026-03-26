module git.clone;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

enum git_clone_local_t
{
    local_auto = 0,
    local = 1,
    no_local = 2,
    local_no_links = 3
}

alias git_remote_create_cb = int function(
    git_remote** remote_out,
    git_repository* repo,
    const(char)* name,
    const(char)* url,
    void* payload
);

alias git_repository_create_cb = int function(
    git_repository** repo_out,
    const(char)* path,
    int bare,
    void* payload
);

struct git_clone_options
{
    uint version_;
    git_checkout_options checkout_opts;
    git_fetch_options fetch_opts;
    int bare;
    git_clone_local_t local;
    const(char)* checkout_branch;
    git_repository_create_cb repository_cb;
    void* repository_cb_payload;
    git_remote_create_cb remote_cb;
    void* remote_cb_payload;
}

enum GIT_CLONE_OPTIONS_VERSION = 1;

int git_clone_options_init(git_clone_options* opts, uint version_);

int git_clone(
    git_repository** repo_out,
    const(char)* url,
    const(char)* local_path,
    const(git_clone_options)* options
);