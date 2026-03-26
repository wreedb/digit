module git.status;
import core.stdc.config;
alias size_t = c_ulong;
import git;

extern (C):

enum git_status_t : uint
{
    current = 0,
    index_new = (1u << 0),
    index_modified = (1u << 1),
    index_deleted = (1u << 2),
    index_renamed = (1u << 3),
    index_typechange = (1u << 4),
    wt_new = (1u << 7),
    wt_modified = (1u << 8),
    wt_deleted = (1u << 9),
    wt_typechange = (1u << 10),
    wt_renamed = (1u << 11),
    wt_unreadable = (1u << 12),
    ignored = (1u << 14),
    conflicted = (1u << 15)
}

alias git_status_cb = int function(
    const(char)* path,
    uint status_flags,
    void* payload
);

enum git_status_show_t : uint
{
    index_and_workdir = 0,
    index_only = 1,
    workdir_only = 2
}

enum git_status_opt_t
{
    include_untracked = (1u << 0),
    include_ignored = (1u << 1),
    include_unmodified = (1u << 2),
    exclude_submodules = (1u << 3),
    recurse_untracked_dirs = (1u << 4),
    disable_pathspec_match = (1u << 5),
    recurse_ignored_dirs = (1u << 6),
    renames_head_to_index = (1u << 7),
    renames_index_to_workdir = (1u << 8),
    sort_case_sensitively = (1u << 9),
    sort_case_insensitively = (1u << 10),
    renames_from_rewrites = (1u << 11),
    no_refresh = (1u << 12),
    update_index = (1u << 13),
    include_unreadable = (1u << 14),
    include_unreadable_as_untracked = (1u << 15)
}

enum GIT_STATUS_OPT_DEFAULTS = git_status_opt_t.include_ignored|git_status_opt_t.include_untracked|git_status_opt_t.recurse_untracked_dirs;

struct git_status_options
{
    uint version_;
    git_status_show_t show;
    uint flags;
    git_strarray pathspec;
    git_tree* baseline;
    ushort rename_threshold;
}

enum GIT_STATUS_OPTIONS_VERSION = 1;

int git_status_options_init(git_status_options* opts, uint version_);

struct git_status_entry
{
    git_status_t status;
    git_diff_delta* head_to_index;
    git_diff_delta* index_to_workdir;
}

int git_status_foreach(
    git_repository* repo,
    git_status_cb callback,
    void* payload
);

int git_status_foreach_ext(
    git_repository* repo,
    const(git_status_options)* opts,
    git_status_cb callback,
    void* payload
);

int git_status_file(
    uint* status_flags,
    git_repository* repo,
    const(char)* path
);

int git_status_list_new(
    git_status_list** sl_out,
    git_repository* repo,
    const(git_status_options)* opts
);

size_t git_status_list_entrycount(git_status_list* statuslist);

const(git_status_entry)* git_status_byindex(
    git_status_list* statuslist,
    size_t idx
);

void git_status_list_free(git_status_list* statuslist);

int git_status_should_ignore(
    int* ignored,
    git_repository* repo,
    const(char)* path
);