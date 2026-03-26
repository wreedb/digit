module git.revert;
import core.stdc.config;
alias size_t = c_ulong;
import git;

extern (C):

struct git_revert_options
{
    uint version_;
    uint mainline;
    git_merge_options merge_opts;
    git_checkout_options checkout_opts;
}

enum GIT_REVERT_OPTIONS_VERSION = 1;

int git_revert_options_init(git_revert_options* opts, uint version_);

int git_revert_commit(
    git_index** index_out,
    git_repository* repo,
    git_commit* revert_commit,
    git_commit* our_commit,
    uint mainline,
    const(git_merge_options)* merge_options);

int git_revert(
    git_repository* repo,
    git_commit* commit,
    const(git_revert_options)* given_opts
);