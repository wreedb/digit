module git.revwalk;
import core.stdc.config;
alias size_t = c_ulong;
import git;

extern (C):

enum git_sort_t
{
    none = 0,
    topological = (1 << 0),
    time = (1 << 1),
    reverse = (1 << 2)
}

int git_revwalk_new(git_revwalk** rw_out, git_repository* repo);
int git_revwalk_reset(git_revwalk* walker);
int git_revwalk_push(git_revwalk* walk, const(git_oid)* id);
int git_revwalk_push_glob(git_revwalk* walk, const(char)* glob);
int git_revwalk_push_head(git_revwalk* walk);
int git_revwalk_hide(git_revwalk* walk, const(git_oid)* commit_id);
int git_revwalk_hide_glob(git_revwalk* walk, const(char)* glob);
int git_revwalk_hide_head(git_revwalk* walk);
int git_revwalk_push_ref(git_revwalk* walk, const(char)* refname);
int git_revwalk_hide_ref(git_revwalk* walk, const(char)* refname);
int git_revwalk_next(git_oid* oid_out, git_revwalk* walk);
int git_revwalk_sorting(git_revwalk* walk, uint sort_mode);
int git_revwalk_push_range(git_revwalk* walk, const(char)* range);
int git_revwalk_simplify_first_parent(git_revwalk* walk);
void git_revwalk_free(git_revwalk* walk);
git_repository* git_revwalk_repository(git_revwalk* walk);

alias git_revwalk_hide_cb = int function(
    const(git_oid)* commit_id,
    void* payload
);

int git_revwalk_add_hide_cb(
    git_revwalk* walk,
    git_revwalk_hide_cb hide_cb,
    void* payload
);