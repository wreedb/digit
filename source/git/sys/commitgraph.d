module git.sys.commitgraph;
import git, git.sys;

import core.stdc.config;
alias size_t = c_ulong;

extern (C):

struct git_commit_graph_open_options
{
    uint version_;
}

enum GIT_COMMIT_GRAPH_OPEN_OPTIONS_VERSION = 1;

int git_commit_graph_open_options_init(
    git_commit_graph_open_options* opts,
    uint version_
);

int git_commit_graph_open(
    git_commit_graph** cgraph_out,
    const(char)* objects_dir
);

void git_commit_graph_free(git_commit_graph* cgraph);

enum git_commit_graph_split_strategy_t
{
    single_file = 0
}

struct git_commit_graph_writer_options
{
    uint version_;
    git_commit_graph_split_strategy_t split_strategy;
    float size_multiple;
    size_t max_commits;
}

enum GIT_COMMIT_GRAPH_WRITER_OPTIONS_VERSION = 1;

int git_commit_graph_writer_options_init(
    git_commit_graph_writer_options* opts,
    uint version_
);

int git_commit_graph_writer_new(
    git_commit_graph_writer** cgw_out,
    const(char)* objects_info_dir,
    const(git_commit_graph_writer_options)* options
);

void git_commit_graph_writer_free(git_commit_graph_writer* w);

int git_commit_graph_writer_add_index_file(
    git_commit_graph_writer* w,
    git_repository* repo,
    const(char)* idx_path
);

int git_commit_graph_writer_add_revwalk(
    git_commit_graph_writer* w,
    git_revwalk* walk
);

int git_commit_graph_writer_commit(git_commit_graph_writer* w);
int git_commit_graph_writer_dump(git_buf* buffer, git_commit_graph_writer* w);