module git.reset;
import core.stdc.config;
alias size_t = c_ulong;
import git;

extern (C):

enum git_reset_t
{
    soft = 1,
    mixed = 2,
    hard = 3
}

int git_reset(
    git_repository* repo,
    const(git_object)* target,
    git_reset_t reset_type,
    const(git_checkout_options)* checkout_opts
);

int git_reset_from_annotated(
    git_repository* repo,
    const(git_annotated_commit)* target,
    git_reset_t reset_type,
    const(git_checkout_options)* checkout_opts
);

int git_reset_default(
    git_repository* repo,
    const(git_object)* target,
    const(git_strarray)* pathspecs
);