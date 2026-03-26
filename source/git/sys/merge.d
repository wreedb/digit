module git.sys.merge;

import core.stdc.config;
alias size_t = c_ulong;

import git, git.sys;

extern (C):

git_merge_driver* git_merge_driver_lookup(const(char)* name);

enum GIT_MERGE_DRIVER_TEXT = "text";
enum GIT_MERGE_DRIVER_BINARY = "binary";
enum GIT_MERGE_DRIVER_UNION = "union";

struct git_merge_driver_source;

git_repository* git_merge_driver_source_repo(const(git_merge_driver_source)* src);

const(git_index_entry)* git_merge_driver_source_ancestor(const(git_merge_driver_source)* src);
const(git_index_entry)* git_merge_driver_source_ours(const(git_merge_driver_source)* src);
const(git_index_entry)* git_merge_driver_source_theirs(const(git_merge_driver_source)* src);
const(git_merge_file_options)* git_merge_driver_source_file_options(const(git_merge_driver_source)* src);
alias git_merge_driver_init_fn = int function(git_merge_driver* self);
alias git_merge_driver_shutdown_fn = void function(git_merge_driver* self);

alias git_merge_driver_apply_fn = int function(
    git_merge_driver* self,
    const(char*)* path_out,
    uint* mode_out,
    git_buf* merged_out,
    const(char)* filter_name,
    const(git_merge_driver_source)* src
);

struct git_merge_driver
{
    uint version_;
    git_merge_driver_init_fn initialize;
    git_merge_driver_shutdown_fn shutdown;
    git_merge_driver_apply_fn apply;
}

enum GIT_MERGE_DRIVER_VERSION = 1;
int git_merge_driver_register(const(char)* name, git_merge_driver* driver);
int git_merge_driver_unregister(const(char)* name);