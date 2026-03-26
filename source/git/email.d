module git.email;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

enum git_email_create_flags_t
{
    normal = 0,
    omit_numbers = (1u << 0),
    always_number = (1u << 1),
    no_renames = (1u << 2)
}

struct git_email_create_options
{
    uint version_;
    uint flags;
    git_diff_options diff_opts;
    git_diff_find_options diff_find_opts;
    const(char)* subject_prefix;
    size_t start_number;
    size_t reroll_number;
}

enum GIT_EMAIL_CREATE_OPTIONS_VERSION = 1;

int git_email_create_from_commit(
    git_buf* buf_out,
    git_commit* commit,
    const(git_email_create_options)* opts
);