module git.repository;

import std.conv : octal;

import git.types,
       git.object,
       git.commit,
       git.buffer,
       git.oid;

extern (C):

int git_repository_open(git_repository** repo, const(char)* path);

int git_repository_open_from_worktree(git_repository** repo, git_worktree* wt);

int git_repository_wrap_odb(git_repository** repo, git_odb* odb);

int git_repository_discover(git_buf* buf, const(char)* start_path, int across_fs, const(char)* ceiling_dirs);

enum git_repository_open_flag_t
{
    GIT_REPOSITORY_OPEN_NO_SEARCH = 1 << 0,
    GIT_REPOSITORY_OPEN_CROSS_FS  = 1 << 1,
    GIT_REPOSITORY_OPEN_BARE      = 1 << 2,
    GIT_REPOSITORY_OPEN_NO_DOTGIT = 1 << 3,
    GIT_REPOSITORY_OPEN_FROM_ENV  = 1 << 4
}

alias GIT_REPOSITORY_OPEN_NO_SEARCH = git_repository_open_flag_t.GIT_REPOSITORY_OPEN_NO_SEARCH;
alias GIT_REPOSITORY_OPEN_CROSS_FS = git_repository_open_flag_t.GIT_REPOSITORY_OPEN_CROSS_FS;
alias GIT_REPOSITORY_OPEN_BARE = git_repository_open_flag_t.GIT_REPOSITORY_OPEN_BARE;
alias GIT_REPOSITORY_OPEN_NO_DOTGIT = git_repository_open_flag_t.GIT_REPOSITORY_OPEN_NO_DOTGIT;
alias GIT_REPOSITORY_OPEN_FROM_ENV = git_repository_open_flag_t.GIT_REPOSITORY_OPEN_FROM_ENV;

int git_repository_open_ext(git_repository** repo, const(char)* path, uint flags, const(char)* ceiling_dirs);

int git_repository_open_bare(git_repository** repo, const(char)* bare_path);

void git_repository_free(git_repository* repo);

int git_repository_init(
    git_repository** repo,
    const(char)* path,
    uint is_bare);
    

enum git_repository_init_flag_t
{
    GIT_REPOSITORY_INIT_BARE              = 1u << 0,
    GIT_REPOSITORY_INIT_NO_REINIT         = 1u << 1,
    GIT_REPOSITORY_INIT_NO_DOTGIT_DIR     = 1u << 2,
    GIT_REPOSITORY_INIT_MKDIR             = 1u << 3,
    GIT_REPOSITORY_INIT_MKPATH            = 1u << 4,
    GIT_REPOSITORY_INIT_EXTERNAL_TEMPLATE = 1u << 5,
    GIT_REPOSITORY_INIT_RELATIVE_GITLINK  = 1u << 6
}

alias GIT_REPOSITORY_INIT_BARE = git_repository_init_flag_t.GIT_REPOSITORY_INIT_BARE;
alias GIT_REPOSITORY_INIT_NO_REINIT = git_repository_init_flag_t.GIT_REPOSITORY_INIT_NO_REINIT;
alias GIT_REPOSITORY_INIT_NO_DOTGIT_DIR = git_repository_init_flag_t.GIT_REPOSITORY_INIT_NO_DOTGIT_DIR;
alias GIT_REPOSITORY_INIT_MKDIR = git_repository_init_flag_t.GIT_REPOSITORY_INIT_MKDIR;
alias GIT_REPOSITORY_INIT_MKPATH = git_repository_init_flag_t.GIT_REPOSITORY_INIT_MKPATH;
alias GIT_REPOSITORY_INIT_EXTERNAL_TEMPLATE = git_repository_init_flag_t.GIT_REPOSITORY_INIT_EXTERNAL_TEMPLATE;
alias GIT_REPOSITORY_INIT_RELATIVE_GITLINK = git_repository_init_flag_t.GIT_REPOSITORY_INIT_RELATIVE_GITLINK;

enum git_repository_init_mode_t
{
    GIT_REPOSITORY_INIT_SHARED_UMASK = 0,
    GIT_REPOSITORY_INIT_SHARED_GROUP = octal!2775,
    GIT_REPOSITORY_INIT_SHARED_ALL   = octal!2777
}

alias GIT_REPOSITORY_INIT_SHARED_UMASK = git_repository_init_mode_t.GIT_REPOSITORY_INIT_SHARED_UMASK;
alias GIT_REPOSITORY_INIT_SHARED_GROUP = git_repository_init_mode_t.GIT_REPOSITORY_INIT_SHARED_GROUP;
alias GIT_REPOSITORY_INIT_SHARED_ALL = git_repository_init_mode_t.GIT_REPOSITORY_INIT_SHARED_ALL;

struct git_repository_init_options
{
    uint version_;
    uint flags;
    uint mode;
    const(char)* workdir_path;
    const(char)* description;
    const(char)* template_path;
    const(char)* initial_head;
    const(char)* origin_url;
}

enum GIT_REPOSITORY_INIT_OPTIONS_VERSION = 1;

int git_repository_init_options_init(git_repository_init_options* options, uint vers);

int git_repository_init_ext(
    git_repository** repo,
    const(char)* repo_path,
    git_repository_init_options* options
);
    
int git_repository_head(git_reference** gref, git_repository* repo);

int git_repository_head_for_worktree(
    git_reference** gref,
    git_repository* repo,
    const(char)* name
);

int git_repository_head_detached(git_repository* repo);

int git_repository_head_detached_for_worktree(
    git_repository* repo,
    const(char)* name
);

int git_repository_head_unborn(git_repository* repo);

int git_repository_is_empty(git_repository* repo);


enum git_repository_item_t
{
    GIT_REPOSITORY_ITEM_GITDIR          = 0,
    GIT_REPOSITORY_ITEM_WORKDIR         = 1,
    GIT_REPOSITORY_ITEM_COMMONDIR       = 2,
    GIT_REPOSITORY_ITEM_INDEX           = 3,
    GIT_REPOSITORY_ITEM_OBJECTS         = 4,
    GIT_REPOSITORY_ITEM_REFS            = 5,
    GIT_REPOSITORY_ITEM_PACKED_REFS     = 6,
    GIT_REPOSITORY_ITEM_REMOTES         = 7,
    GIT_REPOSITORY_ITEM_CONFIG          = 8,
    GIT_REPOSITORY_ITEM_INFO            = 9,
    GIT_REPOSITORY_ITEM_HOOKS           = 10,
    GIT_REPOSITORY_ITEM_LOGS            = 11,
    GIT_REPOSITORY_ITEM_MODULES         = 12,
    GIT_REPOSITORY_ITEM_WORKTREES       = 13,
    GIT_REPOSITORY_ITEM_WORKTREE_CONFIG = 14,
    GIT_REPOSITORY_ITEM__LAST           = 15
}

alias GIT_REPOSITORY_ITEM_GITDIR = git_repository_item_t.GIT_REPOSITORY_ITEM_GITDIR;
alias GIT_REPOSITORY_ITEM_WORKDIR = git_repository_item_t.GIT_REPOSITORY_ITEM_WORKDIR;
alias GIT_REPOSITORY_ITEM_COMMONDIR = git_repository_item_t.GIT_REPOSITORY_ITEM_COMMONDIR;
alias GIT_REPOSITORY_ITEM_INDEX = git_repository_item_t.GIT_REPOSITORY_ITEM_INDEX;
alias GIT_REPOSITORY_ITEM_OBJECTS = git_repository_item_t.GIT_REPOSITORY_ITEM_OBJECTS;
alias GIT_REPOSITORY_ITEM_REFS = git_repository_item_t.GIT_REPOSITORY_ITEM_REFS;
alias GIT_REPOSITORY_ITEM_PACKED_REFS = git_repository_item_t.GIT_REPOSITORY_ITEM_PACKED_REFS;
alias GIT_REPOSITORY_ITEM_REMOTES = git_repository_item_t.GIT_REPOSITORY_ITEM_REMOTES;
alias GIT_REPOSITORY_ITEM_CONFIG = git_repository_item_t.GIT_REPOSITORY_ITEM_CONFIG;
alias GIT_REPOSITORY_ITEM_INFO = git_repository_item_t.GIT_REPOSITORY_ITEM_INFO;
alias GIT_REPOSITORY_ITEM_HOOKS = git_repository_item_t.GIT_REPOSITORY_ITEM_HOOKS;
alias GIT_REPOSITORY_ITEM_LOGS = git_repository_item_t.GIT_REPOSITORY_ITEM_LOGS;
alias GIT_REPOSITORY_ITEM_MODULES = git_repository_item_t.GIT_REPOSITORY_ITEM_MODULES;
alias GIT_REPOSITORY_ITEM_WORKTREES = git_repository_item_t.GIT_REPOSITORY_ITEM_WORKTREES;
alias GIT_REPOSITORY_ITEM_WORKTREE_CONFIG = git_repository_item_t.GIT_REPOSITORY_ITEM_WORKTREE_CONFIG;
alias GIT_REPOSITORY_ITEM__LAST = git_repository_item_t.GIT_REPOSITORY_ITEM__LAST;

int git_repository_item_path(git_buf* buf, const(git_repository)* repo, git_repository_item_t item);

const(char)* git_repository_path(const(git_repository)* repo);


const(char)* git_repository_workdir(const(git_repository)* repo);
const(char)* git_repository_commondir(const(git_repository)* repo);

int git_repository_set_workdir(
    git_repository* repo,
    const(char)* workdir,
    int update_gitlink
);


int git_repository_is_bare(const(git_repository)* repo);
int git_repository_is_worktree(const(git_repository)* repo);

int git_repository_config(git_config** conf, git_repository* repo);
int git_repository_config_snapshot(git_config** conf, git_repository* repo);

int git_repository_odb(git_odb** odb, git_repository* repo);
int git_repository_refdb(git_refdb** refdb, git_repository* repo);
int git_repository_index(git_index** index, git_repository* repo);

int git_repository_message(git_buf* buf, git_repository* repo);
int git_repository_message_remove(git_repository* repo);
int git_repository_state_cleanup(git_repository* repo);

alias git_repository_fetchhead_foreach_cb = int function(
    const(char)* ref_name,
    const(char)* remote_url,
    const(git_oid)* oid,
    uint is_merge,
    void* payload
);

int git_repository_fetchhead_foreach(
    git_repository* repo,
    git_repository_fetchhead_foreach_cb callback,
    void* payload
);

alias git_repository_mergehead_foreach_cb = int function(
    const(git_oid)* oid,
    void* payload
);

int git_repository_mergehead_foreach(
    git_repository* repo,
    git_repository_mergehead_foreach_cb callback,
    void* payload
);

int git_repository_hashfile(
    git_oid* oid_out,
    git_repository* repo,
    const(char)* path,
    git_object_t type,
    const(char)* as_path
);

int git_repository_set_head(git_repository* repo, const(char)* refname);

int git_repository_set_head_detached(
    git_repository* repo,
    const(git_oid)* committish
);

int git_repository_set_head_detached_from_annotated(
    git_repository* repo,
    const(git_annotated_commit)* committish
);

int git_repository_detach_head(git_repository* repo);


enum git_repository_state_t
{
    GIT_REPOSITORY_STATE_NONE                    = 0,
    GIT_REPOSITORY_STATE_MERGE                   = 1,
    GIT_REPOSITORY_STATE_REVERT                  = 2,
    GIT_REPOSITORY_STATE_REVERT_SEQUENCE         = 3,
    GIT_REPOSITORY_STATE_CHERRYPICK              = 4,
    GIT_REPOSITORY_STATE_CHERRYPICK_SEQUENCE     = 5,
    GIT_REPOSITORY_STATE_BISECT                  = 6,
    GIT_REPOSITORY_STATE_REBASE                  = 7,
    GIT_REPOSITORY_STATE_REBASE_INTERACTIVE      = 8,
    GIT_REPOSITORY_STATE_REBASE_MERGE            = 9,
    GIT_REPOSITORY_STATE_APPLY_MAILBOX           = 10,
    GIT_REPOSITORY_STATE_APPLY_MAILBOX_OR_REBASE = 11
}

alias GIT_REPOSITORY_STATE_NONE = git_repository_state_t.GIT_REPOSITORY_STATE_NONE;
alias GIT_REPOSITORY_STATE_MERGE = git_repository_state_t.GIT_REPOSITORY_STATE_MERGE;
alias GIT_REPOSITORY_STATE_REVERT = git_repository_state_t.GIT_REPOSITORY_STATE_REVERT;
alias GIT_REPOSITORY_STATE_REVERT_SEQUENCE = git_repository_state_t.GIT_REPOSITORY_STATE_REVERT_SEQUENCE;
alias GIT_REPOSITORY_STATE_CHERRYPICK = git_repository_state_t.GIT_REPOSITORY_STATE_CHERRYPICK;
alias GIT_REPOSITORY_STATE_CHERRYPICK_SEQUENCE = git_repository_state_t.GIT_REPOSITORY_STATE_CHERRYPICK_SEQUENCE;
alias GIT_REPOSITORY_STATE_BISECT = git_repository_state_t.GIT_REPOSITORY_STATE_BISECT;
alias GIT_REPOSITORY_STATE_REBASE = git_repository_state_t.GIT_REPOSITORY_STATE_REBASE;
alias GIT_REPOSITORY_STATE_REBASE_INTERACTIVE = git_repository_state_t.GIT_REPOSITORY_STATE_REBASE_INTERACTIVE;
alias GIT_REPOSITORY_STATE_REBASE_MERGE = git_repository_state_t.GIT_REPOSITORY_STATE_REBASE_MERGE;
alias GIT_REPOSITORY_STATE_APPLY_MAILBOX = git_repository_state_t.GIT_REPOSITORY_STATE_APPLY_MAILBOX;
alias GIT_REPOSITORY_STATE_APPLY_MAILBOX_OR_REBASE = git_repository_state_t.GIT_REPOSITORY_STATE_APPLY_MAILBOX_OR_REBASE;

int git_repository_state(git_repository* repo);
int git_repository_set_namespace(git_repository* repo, const(char)* name);

const(char)* git_repository_get_namespace(git_repository* repo);

int git_repository_is_shallow(git_repository* repo);
int git_repository_ident(const(char*)* name, const(char*)* email, const(git_repository)* repo);
int git_repository_set_ident(git_repository* repo, const(char)* name, const(char)* email);
git_oid_t git_repository_oid_type(git_repository* repo);
int git_repository_commit_parents(git_commitarray* commits, git_repository* repo);