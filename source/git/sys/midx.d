module git.sys.midx;

import core.stdc.config;
alias size_t = c_ulong;

import git, git.sys;

extern (C):

struct git_midx_writer_options
{
    uint version_;
}

enum GIT_MIDX_WRITER_OPTIONS_VERSION = 1;

int git_midx_writer_options_init(git_midx_writer_options* opts, uint version_);
int git_midx_writer_new(git_midx_writer** mwr_out, const(char)* pack_dir);
void git_midx_writer_free(git_midx_writer* w);
int git_midx_writer_add(git_midx_writer* w, const(char)* idx_path);
int git_midx_writer_commit(git_midx_writer* w);
int git_midx_writer_dump(git_buf* midx, git_midx_writer* w);