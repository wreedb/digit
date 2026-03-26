module git.odb;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

enum git_odb_lookup_flags_t
{
    no_refresh = (1 << 0)
}

alias git_odb_foreach_cb = int function(const(git_oid)* id, void* payload);

struct git_odb_options
{
    uint version_;
    git_oid_t oid_type;
}

enum GIT_ODB_OPTIONS_VERSION = 1;

int git_odb_new(git_odb** odb);
int git_odb_open(git_odb** odb_out, const(char)* objects_dir);
int git_odb_add_disk_alternate(git_odb* odb, const(char)* path);
void git_odb_free(git_odb* db);
int git_odb_read(git_odb_object** obj, git_odb* db, const(git_oid)* id);
int git_odb_read_prefix(git_odb_object** obj, git_odb* db, const(git_oid)* short_id, size_t len);
int git_odb_read_header(size_t* len_out, git_object_t* type_out, git_odb* db, const(git_oid)* id);
int git_odb_exists(git_odb* db, const(git_oid)* id);
int git_odb_exists_ext(git_odb* db, const(git_oid)* id, uint flags);

int git_odb_exists_prefix(
    git_oid* oid_out,
    git_odb* db,
    const(git_oid)* short_id,
    size_t len
);

struct git_odb_expand_id
{
    git_oid id;
    ushort length;
    git_object_t type;
}

int git_odb_expand_ids(git_odb* db, git_odb_expand_id* ids, size_t count);
int git_odb_refresh(git_odb* db);
int git_odb_foreach(git_odb* db, git_odb_foreach_cb cb, void* payload);
int git_odb_write(git_oid* oid_out, git_odb* odb, const(void)* data, size_t len, git_object_t type);
int git_odb_open_wstream(git_odb_stream** odbstream_out, git_odb* db, git_object_size_t size, git_object_t type);
int git_odb_stream_write(git_odb_stream* stream, const(char)* buffer, size_t len);
int git_odb_stream_finalize_write(git_oid* oid_out, git_odb_stream* stream);
int git_odb_stream_read(git_odb_stream* stream, char* buffer, size_t len);
void git_odb_stream_free(git_odb_stream* stream);

int git_odb_open_rstream(
    git_odb_stream** odbstream_out,
    size_t* len,
    git_object_t* type,
    git_odb* db,
    const(git_oid)* oid
);

int git_odb_write_pack(
    git_odb_writepack** wrpack_out,
    git_odb* db,
    git_indexer_progress_cb progress_cb,
    void* progress_payload
);

int git_odb_write_multi_pack_index(git_odb* db);
int git_odb_hash(git_oid* oid, const(void)* data, size_t len, git_object_t object_type);
int git_odb_hashfile(git_oid* oid, const(char)* path, git_object_t object_type);
int git_odb_object_dup(git_odb_object** dest, git_odb_object* source);
void git_odb_object_free(git_odb_object* object);
const(git_oid)* git_odb_object_id(git_odb_object* object);
const(void)* git_odb_object_data(git_odb_object* object);
size_t git_odb_object_size(git_odb_object* object);
git_object_t git_odb_object_type(git_odb_object* object);
int git_odb_add_backend(git_odb* odb, git_odb_backend* backend, int priority);
int git_odb_add_alternate(git_odb* odb, git_odb_backend* backend, int priority);
size_t git_odb_num_backends(git_odb* odb);
int git_odb_get_backend(git_odb_backend** odbback_out, git_odb* odb, size_t pos);
int git_odb_set_commit_graph(git_odb* odb, git_commit_graph* cgraph);