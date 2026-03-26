module git.branch;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

int git_branch_create(
    git_reference** ref_out,
    git_repository* repo,
    const(char)* branch_name,
    const(git_commit)* target,
    int force
);

int git_branch_create_from_annotated(
    git_reference** ref_out,
    git_repository* repo,
    const(char)* branch_name,
    const(git_annotated_commit)* target,
    int force
);

int git_branch_delete(git_reference* branch);

struct git_branch_iterator;

int git_branch_iterator_new(
    git_branch_iterator** iter_out,
    git_repository* repo,
    git_branch_t list_flags
);

int git_branch_next(git_reference** ref_out, git_branch_t* out_type, git_branch_iterator* iter);

void git_branch_iterator_free(git_branch_iterator* iter);

int git_branch_move(
    git_reference** ref_out,
    git_reference* branch,
    const(char)* new_branch_name,
    int force
);

int git_branch_lookup(
    git_reference** out_,
    git_repository* repo,
    const(char)* branch_name,
    git_branch_t branch_type
);

int git_branch_name(const(char*)* name_out, const(git_reference)* gref);
int git_branch_upstream(git_reference** ref_out, const(git_reference)* branch);
int git_branch_set_upstream(git_reference* branch, const(char)* branch_name);

int git_branch_upstream_name(
    git_buf* buf_out,
    git_repository* repo,
    const(char)* refname
);

int git_branch_is_head(const(git_reference)* branch);
int git_branch_is_checked_out(const(git_reference)* branch);

int git_branch_remote_name(
    git_buf* buf_out,
    git_repository* repo,
    const(char)* refname
);

int git_branch_upstream_remote(git_buf* buf, git_repository* repo, const(char)* refname);
int git_branch_upstream_merge(git_buf* buf, git_repository* repo, const(char)* refname);
int git_branch_name_is_valid(int* valid, const(char)* name);