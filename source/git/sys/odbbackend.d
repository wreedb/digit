module git.sys.odbbackend;

import core.stdc.config;
alias size_t = c_ulong;

import git, git.sys;

extern (C):

struct git_odb_backend
{
    uint version_;
    git_odb* odb;

    int function(
        void**,
        size_t*,
        git_object_t*,
        git_odb_backend*,
        const(git_oid)*
    ) read;

    int function(
        git_oid*,
        void**,
        size_t*,
        git_object_t*,
        git_odb_backend*,
        const(git_oid)*,
        size_t
    ) read_prefix;

    int function(
        size_t*,
        git_object_t*,
        git_odb_backend*,
        const(git_oid)*
    ) read_header;

    int function(
        git_odb_backend*,
        const(git_oid)*,
        const(void)*,
        size_t,
        git_object_t
    ) write;

    int function(
        git_odb_stream**,
        git_odb_backend*,
        git_object_size_t,
        git_object_t
    ) writestream;

    int function(
        git_odb_stream**,
        size_t*,
        git_object_t*,
        git_odb_backend*,
        const(git_oid)*
    ) readstream;

    int function(git_odb_backend*, const(git_oid)*) exists;

    int function(
        git_oid*,
        git_odb_backend*,
        const(git_oid)*,
        size_t
    ) exists_prefix;

    int function(git_odb_backend*) refresh;

    int function(
        git_odb_backend*,
        git_odb_foreach_cb cb,
        void* payload
    ) foreach_;

    int function(
        git_odb_writepack**,
        git_odb_backend*,
        git_odb* odb,
        git_indexer_progress_cb progress_cb,
        void* progress_payload
    ) writepack;

    int function(git_odb_backend*) writemidx;
    int function(git_odb_backend*, const(git_oid)*) freshen;
    void function(git_odb_backend*) free;
}

enum GIT_ODB_BACKEND_VERSION = 1;

int git_odb_init_backend(git_odb_backend* backend, uint version_);
void* git_odb_backend_data_alloc(git_odb_backend* backend, size_t len);
void git_odb_backend_data_free(git_odb_backend* backend, void* data);
void* git_odb_backend_malloc(git_odb_backend* backend, size_t len);