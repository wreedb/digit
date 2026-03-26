module git.odbbackend;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

struct git_odb_backend_pack_options
{
    uint version_;
    git_oid_t oid_type;
}

enum GIT_ODB_BACKEND_PACK_OPTIONS_VERSION = 1;

enum git_odb_backend_loose_flag_t
{
    fsync = (1 << 0)
}

struct git_odb_backend_loose_options
{
    uint version_;
    uint flags;
    int compression_level;
    uint dir_mode;
    uint file_mode;
    git_oid_t oid_type;
}

enum GIT_ODB_BACKEND_LOOSE_OPTIONS_VERSION = 1;

int git_odb_backend_pack(git_odb_backend** odbback_out, const(char)* objects_dir);
int git_odb_backend_one_pack(git_odb_backend** odbback_out, const(char)* index_file);

int git_odb_backend_loose(
    git_odb_backend** odbback_out,
    const(char)* objects_dir,
    int compression_level,
    int do_fsync,
    uint dir_mode,
    uint file_mode
);

enum git_odb_stream_t
{
    rdonly = (1 << 1),
    wronly = (1 << 2),
    rw = rdonly|wronly
}

struct git_odb_stream
{
    git_odb_backend* backend;
    uint mode;
    void* hash_context;

    git_object_size_t declared_size;
    git_object_size_t received_bytes;

    int function(git_odb_stream* s, char* buffer, size_t len) read;
    int function(git_odb_stream* s, const(char)* buffer, size_t len) write;
    int function(git_odb_stream* s, const(git_oid)* oid) finalize_write;
    void function(git_odb_stream* s) free;
}

struct git_odb_writepack
{
    git_odb_backend* backend;
    int function(git_odb_writepack* wrpack, const(void)* data, size_t size, git_indexer_progress* stats) append;
    int function(git_odb_writepack* wrpack, git_indexer_progress* stats) commit;
    void function(git_odb_writepack* wrpack) free;
}
