module git.sys.filter;

import core.stdc.config;
alias size_t = c_ulong;

import git, git.sys;

extern (C):

git_filter* git_filter_lookup(const(char)* name);

enum GIT_FILTER_CRLF = "crlf";
enum GIT_FILTER_IDENT = "ident";
enum GIT_FILTER_CRLF_PRIORITY = 0;
enum GIT_FILTER_IDENT_PRIORITY = 100;
enum GIT_FILTER_DRIVER_PRIORITY = 200;

int git_filter_list_new(
    git_filter_list** fl_out,
    git_repository* repo,
    git_filter_mode_t mode,
    uint options
);

int git_filter_list_push(
    git_filter_list* fl,
    git_filter* filter,
    void* payload
);

size_t git_filter_list_length(const(git_filter_list)* fl);

struct git_filter_source;

git_repository* git_filter_source_repo(const(git_filter_source)* src);
const(char)* git_filter_source_path(const(git_filter_source)* src);
ushort git_filter_source_filemode(const(git_filter_source)* src);
const(git_oid)* git_filter_source_id(const(git_filter_source)* src);
git_filter_mode_t git_filter_source_mode(const(git_filter_source)* src);
uint git_filter_source_flags(const(git_filter_source)* src);
alias git_filter_init_fn = int function(git_filter* self);
alias git_filter_shutdown_fn = void function(git_filter* self);

alias git_filter_check_fn = int function(
    git_filter* self,
    void** payload,
    const(git_filter_source)* src,
    const(char*)* attr_values
);

alias git_filter_apply_fn = int function(
    git_filter* self,
    void** payload,
    git_buf* to,
    const(git_buf)* from,
    const(git_filter_source)* src
);

alias git_filter_stream_fn = int function(
    git_writestream** wstrm_out,
    git_filter* self,
    void** payload,
    const(git_filter_source)* src,
    git_writestream* next
);

alias git_filter_cleanup_fn = void function(git_filter* self, void* payload);

struct git_filter
{
    uint version_;
    const(char)* attributes;
    git_filter_init_fn initialize;
    git_filter_shutdown_fn shutdown;
    git_filter_check_fn check;
    git_filter_apply_fn apply;
    git_filter_stream_fn stream;
    git_filter_cleanup_fn cleanup;
}

enum GIT_FILTER_VERSION = 1;

int git_filter_init(git_filter* filter, uint version_);
int git_filter_register(const(char)* name, git_filter* filter, int priority);
int git_filter_unregister(const(char)* name);