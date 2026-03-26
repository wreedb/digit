module git.blob;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

int git_blob_lookup(git_blob** blob, git_repository* repo, const(git_oid)* id);
int git_blob_lookup_prefix(git_blob** blob, git_repository* repo, const(git_oid)* id, size_t len);
void git_blob_free(git_blob* blob);
const(git_oid)* git_blob_id(const(git_blob)* blob);
git_repository* git_blob_owner(const(git_blob)* blob);
const(void)* git_blob_rawcontent(const(git_blob)* blob);
git_object_size_t git_blob_rawsize(const(git_blob)* blob);

enum git_blob_filter_flag_t
{
    check_for_binary = (1 << 0),
    no_system_attributes = (1 << 1),
    attributes_from_head = (1 << 2),
    attributes_from_commit = (1 << 3),
}

struct git_blob_filter_options
{
    int version_;
    uint flags;
    git_oid* commit_id;
    git_oid attr_commit_id;
}

enum GIT_BLOB_FILTER_OPTIONS_VERSION = 1;

int git_blob_filter_options_init(git_blob_filter_options* opts, uint version_);

int git_blob_filter(
    git_buf* out_,
    git_blob* blob,
    const(char)* as_path,
    git_blob_filter_options* opts
);

int git_blob_create_from_workdir(git_oid* id, git_repository* repo, const(char)* relative_path);

int git_blob_create_from_disk(
    git_oid* id,
    git_repository* repo,
    const(char)* path
);

int git_blob_create_from_stream(
    git_writestream** stream_out,
    git_repository* repo,
    const(char)* hintpath
);

int git_blob_create_from_stream_commit(git_oid* oid_out, git_writestream* stream);

int git_blob_create_from_buffer(
    git_oid* id,
    git_repository* repo,
    const(void)* buffer,
    size_t len
);

int git_blob_is_binary(const(git_blob)* blob);
int git_blob_data_is_binary(const(char)* data, size_t len);
int git_blob_dup(git_blob** blob_out, git_blob* source);