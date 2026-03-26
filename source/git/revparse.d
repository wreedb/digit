module git.revparse;

import
    git.types,
    git.repository,
    git.object;

extern (C):

int git_revparse_single(
    git_object** object_out,
    git_repository* repo,
    const(char)* spec);

int git_revparse_ext(
    git_object** object_out,
    git_reference** reference_out,
    git_repository* repo,
    const(char)* spec
);

enum git_revspec_t
{
    GIT_REVSPEC_SINGLE     = 1 << 0,
    GIT_REVSPEC_RANGE      = 1 << 1,
    GIT_REVSPEC_MERGE_BASE = 1 << 2
}

alias GIT_REVSPEC_SINGLE = git_revspec_t.GIT_REVSPEC_SINGLE;
alias GIT_REVSPEC_RANGE = git_revspec_t.GIT_REVSPEC_RANGE;
alias GIT_REVSPEC_MERGE_BASE = git_revspec_t.GIT_REVSPEC_MERGE_BASE;

struct git_revspec
{
    git_object* from;
    git_object* to;
    uint flags;
}

int git_revparse(git_revspec* revspec, git_repository* repo, const(char)* spec);