module git.submodule;
import core.stdc.config;
alias size_t = c_ulong;
import git;

extern (C):

enum git_submodule_status_t : uint
{
    in_head = (1u << 0),
    in_index = (1u << 1),
    in_config = (1u << 2),
    in_wd = (1u << 3),
    index_added = (1u << 4),
    index_deleted = (1u << 5),
    index_modified = (1u << 6),
    wd_uninitialized = (1u << 7),
    wd_added = (1u << 8),
    wd_deleted = (1u << 9),
    wd_modified = (1u << 10),
    wd_index_modified = (1u << 11),
    wd_wd_modified = (1u << 12),
    wd_untracked = (1u << 13)
}

enum GIT_SUBMODULE_STATUS__IN_FLAGS = 0x000Fu;
enum GIT_SUBMODULE_STATUS__INDEX_FLAGS = 0x0070u;
enum GIT_SUBMODULE_STATUS__WD_FLAGS = 0x3F80u;

extern (D) auto GIT_SUBMODULE_STATUS_IS_UNMODIFIED(T)(auto ref T S)
{
    return (S & ~GIT_SUBMODULE_STATUS__IN_FLAGS) == 0;
}

extern (D) auto GIT_SUBMODULE_STATUS_IS_INDEX_UNMODIFIED(T)(auto ref T S)
{
    return (S & GIT_SUBMODULE_STATUS__INDEX_FLAGS) == 0;
}

extern (D) auto GIT_SUBMODULE_STATUS_IS_WD_UNMODIFIED(T)(auto ref T S)
{
    return (S & (GIT_SUBMODULE_STATUS__WD_FLAGS & ~git_submodule_status_t.GIT_SUBMODULE_STATUS_WD_UNINITIALIZED)) == 0;
}

extern (D) auto GIT_SUBMODULE_STATUS_IS_WD_DIRTY(T)(auto ref T S)
{
    return (S & (git_submodule_status_t.wd_index_modified | git_submodule_status_t.wd_wd_modified | git_submodule_status_t.wd_untracked)) != 0;
}

alias git_submodule_cb = int function(
    git_submodule* sm,
    const(char)* name,
    void* payload
);

struct git_submodule_update_options
{
    uint version_;
    git_checkout_options checkout_opts;
    git_fetch_options fetch_opts;
    int allow_fetch;
}

enum GIT_SUBMODULE_UPDATE_OPTIONS_VERSION = 1;

int git_submodule_update_options_init(
    git_submodule_update_options* opts,
    uint version_);

int git_submodule_update(git_submodule* submodule, int init, git_submodule_update_options* options);

int git_submodule_lookup(
    git_submodule** sm_out,
    git_repository* repo,
    const(char)* name
);

int git_submodule_dup(git_submodule** sm_out, git_submodule* source);

void git_submodule_free(git_submodule* submodule);

int git_submodule_foreach(
    git_repository* repo,
    git_submodule_cb callback,
    void* payload
);

int git_submodule_add_setup(
    git_submodule** sm_out,
    git_repository* repo,
    const(char)* url,
    const(char)* path,
    int use_gitlink
);

int git_submodule_clone(
    git_repository** repo_out,
    git_submodule* submodule,
    const(git_submodule_update_options)* opts
);

int git_submodule_add_finalize(git_submodule* submodule);
int git_submodule_add_to_index(git_submodule* submodule, int write_index);
git_repository* git_submodule_owner(git_submodule* submodule);
const(char)* git_submodule_name(git_submodule* submodule);
const(char)* git_submodule_path(git_submodule* submodule);
const(char)* git_submodule_url(git_submodule* submodule);
int git_submodule_resolve_url(git_buf* buf_out, git_repository* repo, const(char)* url);
const(char)* git_submodule_branch(git_submodule* submodule);

int git_submodule_set_branch(git_repository* repo, const(char)* name, const(char)* branch);
int git_submodule_set_url(git_repository* repo, const(char)* name, const(char)* url);

const(git_oid)* git_submodule_index_id(git_submodule* submodule);
const(git_oid)* git_submodule_head_id(git_submodule* submodule);
const(git_oid)* git_submodule_wd_id(git_submodule* submodule);

git_submodule_ignore_t git_submodule_ignore(git_submodule* submodule);

int git_submodule_set_ignore(
    git_repository* repo,
    const(char)* name,
    git_submodule_ignore_t ignore
);

git_submodule_update_t git_submodule_update_strategy(git_submodule* submodule);

int git_submodule_set_update(
    git_repository* repo,
    const(char)* name,
    git_submodule_update_t update
);

git_submodule_recurse_t git_submodule_fetch_recurse_submodules(
    git_submodule* submodule
);

int git_submodule_set_fetch_recurse_submodules(
    git_repository* repo,
    const(char)* name,
    git_submodule_recurse_t fetch_recurse_submodules
);

int git_submodule_init(git_submodule* submodule, int overwrite);

int git_submodule_repo_init(
    git_repository** repo_out,
    const(git_submodule)* sm,
    int use_gitlink
);

int git_submodule_sync(git_submodule* submodule);
int git_submodule_open(git_repository** repo, git_submodule* submodule);
int git_submodule_reload(git_submodule* submodule, int force);

int git_submodule_status(
    uint* status,
    git_repository* repo,
    const(char)* name,
    git_submodule_ignore_t ignore
);

int git_submodule_location(uint* location_status, git_submodule* submodule);