module git.sys.diff;

import core.stdc.config;
alias size_t = c_ulong;

import git, git.sys;

extern (C):

int git_diff_print_callback__to_buf(
    const(git_diff_delta)* delta,
    const(git_diff_hunk)* hunk,
    const(git_diff_line)* line,
    void* payload
);

int git_diff_print_callback__to_file_handle(
    const(git_diff_delta)* delta,
    const(git_diff_hunk)* hunk,
    const(git_diff_line)* line,
    void* payload
);

struct git_diff_perfdata
{
    uint version_;
    size_t stat_calls;
    size_t oid_calculations;
}

enum GIT_DIFF_PERFDATA_VERSION = 1;

int git_diff_get_perfdata(git_diff_perfdata* diff_pd_out, const(git_diff)* diff);

int git_status_list_get_perfdata(
    git_diff_perfdata* diff_pd_out,
    const(git_status_list)* status
);