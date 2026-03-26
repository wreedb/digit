module git.sys.email;

import core.stdc.config;
alias size_t = c_ulong;

import git, git.sys;

extern (C):

int git_email_create_from_diff(
    git_buf* buf_out,
    git_diff* diff,
    size_t patch_idx,
    size_t patch_count,
    const(git_oid)* commit_id,
    const(char)* summary,
    const(char)* bodytext,
    const(git_signature)* author,
    const(git_email_create_options)* opts
);