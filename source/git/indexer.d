module git.indexer;

import core.stdc.config : c_ulong;
alias size_t = c_ulong;

import git.types, git.oid;

extern (C):

struct git_indexer;

struct git_indexer_progress
{
    uint total_objects;
    uint indexed_objects;
    uint received_objects;
    uint local_objects;
    uint total_deltas;
    uint indexed_deltas;
    size_t received_bytes;
}

alias git_indexer_progress_cb = int function(const(git_indexer_progress)* stats, void* payload);

struct git_indexer_options
{
    uint version_;
    git_indexer_progress_cb progress_cb;
    void* progress_cb_payload;
    ubyte verify;
}

enum GIT_INDEXER_OPTIONS_VERSION = 1;

int git_indexer_options_init(git_indexer_options* opts, uint version_);

int git_indexer_new(
    git_indexer** indexer_out,
    const(char)* path,
    uint mode,
    git_odb* odb,
    git_indexer_options* options
);

int git_indexer_append(git_indexer* idx, const(void)* data, size_t size, git_indexer_progress* stats);
int git_indexer_commit(git_indexer* idx, git_indexer_progress* stats);
const(git_oid)* git_indexer_hash(const(git_indexer)* idx);
const(char)* git_indexer_name(const(git_indexer)* idx);
void git_indexer_free(git_indexer* idx);