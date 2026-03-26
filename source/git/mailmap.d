module git.mailmap;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

int git_mailmap_new(git_mailmap** mm_out);
void git_mailmap_free(git_mailmap* mm);

int git_mailmap_add_entry(
    git_mailmap* mm,
    const(char)* real_name,
    const(char)* real_email,
    const(char)* replace_name,
    const(char)* replace_email
);

int git_mailmap_from_buffer(git_mailmap** mm_out, const(char)* buf, size_t len);
int git_mailmap_from_repository(git_mailmap** mm_out, git_repository* repo);

int git_mailmap_resolve(
    const(char*)* real_name,
    const(char*)* real_email,
    const(git_mailmap)* mm,
    const(char)* name,
    const(char)* email
);

int git_mailmap_resolve_signature(
    git_signature** sig_out,
    const(git_mailmap)* mm,
    const(git_signature)* sig
);