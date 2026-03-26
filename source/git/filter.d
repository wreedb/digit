module git.filter;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

enum git_filter_mode_t
{
    to_worktree = 0,
    smudge = 0,
    to_odb = 1,
    clean = 1
}

enum git_filter_flag_t
{
    normal = 0u,
    allow_unsafe = (1u << 0),
    no_system_attributes = (1u << 1),
    attributes_from_head = (1u << 2),
    attributes_from_commit = (1u << 3)
}

struct git_filter_options
{
    uint version_;
    uint flags;
    git_oid* commit_id;
    git_oid attr_commit_id;
}

enum GIT_FILTER_OPTIONS_VERSION = 1;

struct git_filter;
struct git_filter_list;

int git_filter_list_load(
    git_filter_list** filters,
    git_repository* repo,
    git_blob* blob,
    const(char)* path,
    git_filter_mode_t mode,
    uint flags
);

int git_filter_list_load_ext(
    git_filter_list** filters,
    git_repository* repo,
    git_blob* blob,
    const(char)* path,
    git_filter_mode_t mode,
    git_filter_options* opts
);

int git_filter_list_contains(git_filter_list* filters, const(char)* name);

int git_filter_list_apply_to_buffer(
    git_buf* buf_out,
    git_filter_list* filters,
    const(char)* str_in,
    size_t in_len
);

int git_filter_list_apply_to_file(
    git_buf* buf_out,
    git_filter_list* filters,
    git_repository* repo,
    const(char)* path
);

int git_filter_list_apply_to_blob(
    git_buf* buf_out,
    git_filter_list* filters,
    git_blob* blob
);

int git_filter_list_stream_buffer(
    git_filter_list* filters,
    const(char)* buffer,
    size_t len,
    git_writestream* target
);

int git_filter_list_stream_file(
    git_filter_list* filters,
    git_repository* repo,
    const(char)* path,
    git_writestream* target
);

int git_filter_list_stream_blob(
    git_filter_list* filters,
    git_blob* blob,
    git_writestream* target
);

void git_filter_list_free(git_filter_list* filters);