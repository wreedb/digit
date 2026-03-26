module git.checkout;

import core.stdc.config;
alias size_t = c_ulong;

import
    git.types,
    git.index,
    git.buffer,
    git.strarray,
    git.tree,
    git.diff,
    git.object,
    git.repository;

extern (C):

enum git_checkout_strategy_t
{
    safe = 0,
    force = 1u << 1,
    recreate_missing = 1u << 2,
    allow_conflicts = 1u << 4,
    remove_untracked = 1u << 5,
    remove_ignored = 1u << 6,
    update_only = 1u << 7,
    dont_update_index = 1u << 8,
    no_refresh = 1u << 9,
    skip_unmerged = 1u << 10,
    use_ours = 1u << 11,
    use_theirs = 1u << 12,
    disable_pathspec_match = 1u << 13,
    skip_locked_directories = 1u << 18,
    dont_overwrite_ignored = 1u << 19,
    conflict_style_merge = 1u << 20,
    conflict_style_diff3 = 1u << 21,
    dont_remove_existing = 1u << 22,
    dont_write_index = 1u << 23,
    dry_run = 1u << 24,
    conflict_style_zdiff3 = 1u << 25,
    none = 1u << 30,
    update_submodules = 1u << 16,
    update_submodules_if_changed = 1u << 17
}

enum git_checkout_notify_t
{
    none = 0,
    conflict = 1u << 0,
    dirty = 1u << 1,
    updated = 1u << 2,
    untracked = 1u << 3,
    ignored = 1u << 4,
    all = 0x0FFFFu
}

struct git_checkout_perfdata
{
    size_t mkdir_calls;
    size_t stat_calls;
    size_t chmod_calls;
}

alias git_checkout_notify_cb = int function(
    git_checkout_notify_t why,
    const(char)* path,
    const(git_diff_file)* baseline,
    const(git_diff_file)* target,
    const(git_diff_file)* workdir,
    void* payload
);

alias git_checkout_progress_cb = void function(
    const(char)* path,
    size_t completed_steps,
    size_t total_steps,
    void* payload
);

alias git_checkout_perfdata_cb = void function(
    const(git_checkout_perfdata)* perfdata,
    void* payload
);

struct git_checkout_options
{
    uint vers;
    uint checkout_strategy;
    int disable_filters;
    uint dir_mode;
    uint file_mode;
    int file_open_flags;
    uint notify_flags;
    git_checkout_notify_cb notify_cb;
    void* notify_payload;
    git_checkout_progress_cb progress_cb;
    void* progress_payload;
    git_strarray paths;
    git_tree* baseline;
    git_index* baseline_index;
    const(char)* target_directory;
    const(char)* ancestor_label;
    const(char)* our_label;
    const(char)* their_label;
    git_checkout_perfdata_cb perfdata_cb;
    void* perfdata_payload;
}

enum GIT_CHECKOUT_OPTIONS_VERSION = 1;

int git_checkout_options_init(git_checkout_options* options, uint version_);
int git_checkout_head(git_repository* repo, const(git_checkout_options)* options);

int git_checkout_index(
    git_repository* repo,
    git_index* index,
    const(git_checkout_options)* opts);

int git_checkout_tree(
    git_repository* repo,
    const(git_object)* treeish,
    const(git_checkout_options)* opts
);