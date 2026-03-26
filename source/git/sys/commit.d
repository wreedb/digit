module git.sys.commit;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

int git_commit_create_from_ids(
    git_oid* id,
    git_repository* repo,
    const(char)* update_ref,
    const(git_signature)* author,
    const(git_signature)* committer,
    const(char)* message_encoding,
    const(char)* message,
    const(git_oid)* tree,
    size_t parent_count,
    const(git_oid)** parents
);

alias git_commit_parent_callback = const(git_oid)* function(size_t idx, void* payload);

int git_commit_create_from_callback(
    git_oid* id,
    git_repository* repo,
    const(char)* update_ref,
    const(git_signature)* author,
    const(git_signature)* committer,
    const(char)* message_encoding,
    const(char)* message,
    const(git_oid)* tree,
    git_commit_parent_callback parent_cb,
    void* parent_payload
);