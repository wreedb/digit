module git.sys.refdbbackend;

import core.stdc.config;
alias size_t = c_ulong;

import git, git.sys;

extern (C):

struct git_reference_iterator
{
    git_refdb* db;

    int function(git_reference** gref, git_reference_iterator* iter) next;

    int function(
        const(char*)* ref_name,
        git_reference_iterator* iter
    ) next_name;

    void function(git_reference_iterator* iter) free;
}

struct git_refdb_backend
{
    uint version_;

    int function(
        int* exists,
        git_refdb_backend* backend,
        const(char)* ref_name
    ) exists;

    int function(
        git_reference** ref_out,
        git_refdb_backend* backend,
        const(char)* ref_name
    ) lookup;

    int function(
        git_reference_iterator** iter,
        git_refdb_backend* backend,
        const(char)* glob
    ) iterator;

    int function(
        git_refdb_backend* backend,
        const(git_reference)* reference,
        int force,
        const(git_signature)* who,
        const(char)* message,
        const(git_oid)* old,
        const(char)* old_target
    ) write;

    int function(
        git_reference** ref_out,
        git_refdb_backend* backend,
        const(char)* old_name,
        const(char)* new_name,
        int force,
        const(git_signature)* who,
        const(char)* message
    ) rename;

    int function(git_refdb_backend* backend, const(char)* ref_name, const(git_oid)* old_id, const(char)* old_target) del;
    int function(git_refdb_backend* backend) compress;
    int function(git_refdb_backend* backend, const(char)* refname) has_log;
    int function(git_refdb_backend* backend, const(char)* refname) ensure_log;
    void function(git_refdb_backend* backend) free;
    int function(git_reflog** rlog_out, git_refdb_backend* backend, const(char)* name) reflog_read;
    int function(git_refdb_backend* be, git_reflog* reflog) reflog_write;
    int function(git_refdb_backend* be, const(char)* old_name, const(char)* new_name) reflog_rename;
    int function(git_refdb_backend* be, const(char)* name) reflog_delete;
    int function(void** payload_out, git_refdb_backend* be, const(char)* refname) lock;

    int function(
        git_refdb_backend* be,
        void* payload,
        int success,
        int update_reflog,
        const(git_reference)* reference,
        const(git_signature)* sig,
        const(char)* message
    ) unlock;
}

enum GIT_REFDB_BACKEND_VERSION = 1;

int git_refdb_init_backend(git_refdb_backend* backend, uint version_);
int git_refdb_backend_fs(git_refdb_backend** backend_out, git_repository* repo);
int git_refdb_set_backend(git_refdb* refdb, git_refdb_backend* backend);
