module git.rebase;

import
    core.stdc.stdint,
    core.stdc.config,
    git;

alias size_t = c_ulong;

extern (C):

struct git_rebase_options
{
    uint version_;
    int quiet;
    int inmemory;
    const(char)* rewrite_notes_ref;
    git_merge_options merge_options;
    git_checkout_options checkout_options;
    git_commit_create_cb commit_create_cb;
    int function(git_buf*, git_buf*, const(char)*, void*) signing_cb;
    void* payload;
}

enum git_rebase_operation_t : uint
{
    pick = 0,
    reword = 1,
    edit = 2,
    squash = 3,
    fixup = 4,
    exec = 5
}

enum GIT_REBASE_OPTIONS_VERSION = 1;

enum GIT_REBASE_NO_OPERATION = SIZE_MAX;

struct git_rebase_operation
{
    git_rebase_operation_t type;
    const git_oid id;
    const(char)* exec;
}

int git_rebase_options_init(git_rebase_options* opts, uint version_);

int git_rebase_init(
    git_rebase** rebase_out,
    git_repository* repo,
    const(git_annotated_commit)* branch,
    const(git_annotated_commit)* upstream,
    const(git_annotated_commit)* onto,
    const(git_rebase_options)* opts
);

int git_rebase_open(
    git_rebase** rebase_out,
    git_repository* repo,
    const(git_rebase_options)* opts
);

const(char)* git_rebase_orig_head_name(git_rebase* rebase);
const(git_oid)* git_rebase_orig_head_id(git_rebase* rebase);
const(char)* git_rebase_onto_name(git_rebase* rebase);
const(git_oid)* git_rebase_onto_id(git_rebase* rebase);
size_t git_rebase_operation_entrycount(git_rebase* rebase);
size_t git_rebase_operation_current(git_rebase* rebase);

git_rebase_operation* git_rebase_operation_byindex(
    git_rebase* rebase,
    size_t idx
);

int git_rebase_next(git_rebase_operation** operation, git_rebase* rebase);
int git_rebase_inmemory_index(git_index** index, git_rebase* rebase);

int git_rebase_commit(
    git_oid* id,
    git_rebase* rebase,
    const(git_signature)* author,
    const(git_signature)* committer,
    const(char)* message_encoding,
    const(char)* message
);

int git_rebase_abort(git_rebase* rebase);
int git_rebase_finish(git_rebase* rebase, const(git_signature)* signature);
void git_rebase_free(git_rebase* rebase);