module git.worktree;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

int git_worktree_list(git_strarray* out_, git_repository* repo);
int git_worktree_lookup(git_worktree** out_, git_repository* repo, const(char)* name);
int git_worktree_open_from_repository(git_worktree** out_, git_repository* repo);
void git_worktree_free(git_worktree* wt);
int git_worktree_validate(const(git_worktree)* wt);

struct git_worktree_add_options
{
    uint version_;
    int lock;
    int checkout_existing;
    git_reference* reference;
    git_checkout_options checkout_options;
}

enum GIT_WORKTREE_ADD_OPTIONS_VERSION = 1;

int git_worktree_add_options_init(
    git_worktree_add_options* opts,
    uint version_);

int git_worktree_add(
    git_worktree** out_,
    git_repository* repo,
    const(char)* name,
    const(char)* path,
    const(git_worktree_add_options)* opts);

int git_worktree_lock(git_worktree* wt, const(char)* reason);

int git_worktree_unlock(git_worktree* wt);

int git_worktree_is_locked(git_buf* reason, const(git_worktree)* wt);

const(char)* git_worktree_name(const(git_worktree)* wt);

const(char)* git_worktree_path(const(git_worktree)* wt);

enum git_worktree_prune_t
{
    GIT_WORKTREE_PRUNE_VALID = 1u << 0,

    GIT_WORKTREE_PRUNE_LOCKED = 1u << 1,

    GIT_WORKTREE_PRUNE_WORKING_TREE = 1u << 2
}

struct git_worktree_prune_options
{
    uint version_;

    uint flags;
}

enum GIT_WORKTREE_PRUNE_OPTIONS_VERSION = 1;

int git_worktree_prune_options_init(
    git_worktree_prune_options* opts,
    uint version_);

int git_worktree_is_prunable(
    git_worktree* wt,
    git_worktree_prune_options* opts);

int git_worktree_prune(git_worktree* wt, git_worktree_prune_options* opts);

