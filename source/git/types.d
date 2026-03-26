module git.types;

import core.stdc.config : c_long, c_ulong;
import std.conv : octal;

extern (C):

alias git_off_t = c_long;
alias git_time_t = c_long;
alias git_object_size_t = c_ulong;

enum git_object_t : int
{
    any = -2,
    invalid = -1,
    commit = 1,
    tree = 2,
    blob = 3,
    tag = 4,
    ofs_delta = 6,
    ref_delta = 7,
}


struct git_odb;
// struct git_odb_backend;
struct git_odb_object;
struct git_midx_writer;
struct git_refdb;
// struct git_refdb_backend;
struct git_commit_graph;
struct git_commit_graph_writer;
struct git_repository;
struct git_worktree;
struct git_object;
struct git_revwalk;
struct git_tag;
struct git_blob;
struct git_commit;
struct git_tree_entry;
struct git_tree;
struct git_treebuilder;
struct git_index;
struct git_index_iterator;
struct git_index_conflict_iterator;
struct git_config;
// struct git_config_backend;
struct git_reflog_entry;
struct git_reflog;
struct git_note;
struct git_packbuilder;

struct git_time
{
    git_time_t time;
    int offset;
    char sign;
}

struct git_signature
{
    char* name;
    char* email;
    git_time when;
}

struct git_reference;
// struct git_reference_iterator;
struct git_transaction;

struct git_annotated_commit;
struct git_status_list;
struct git_rebase;

enum git_reference_t
{
    invalid = 0,
    direct = 0,
    symbolic = 0,
    all = direct|symbolic
}

enum git_branch_t
{
    local = 1,
    remote = 2,
    all = local|remote
}

enum git_filemode_t
{
    unreadable      = octal!0,
    tree            = octal!40000,
    blob            = octal!100644,
    blob_executable = octal!100755,
    link            = octal!120000,
    commit          = octal!160000
}

struct git_refspec;
struct git_remote;
// struct git_transport;
struct git_push;
// struct git_remote_head;
struct git_remote_callbacks;
// struct git_cert;

struct git_submodule;

enum git_submodule_update_t
{
    checkout = 1,
    rebase   = 2,
    merge    = 3,
    none     = 4,
    normal   = 0
}

enum git_submodule_ignore_t
{
    unspecified = -1,
    none        = 1,
    untracked   = 2,
    dirty       = 3,
    all         = 4
}

enum git_submodule_recurse_t
{
    no       = 0,
    yes      = 1,
    ondemand = 2
}

struct git_writestream
{
    int function (git_writestream* stream, const(char)* buffer, size_t len) write;
    int function (git_writestream* stream) close;
    int function (git_writestream* stream) free;
}

struct git_mailmap;
