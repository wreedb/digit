module git.graph;

import core.stdc.config;
alias size_t = c_ulong;

import git.repository, git.oid, git.types;

extern (C):

int git_graph_ahead_behind(size_t* ahead, size_t* behind, git_repository* repo, const(git_oid)* local, const(git_oid)* upstream);

int git_graph_descendant_of(
    git_repository* repo,
    const(git_oid)* commit,
    const(git_oid)* ancestor
);

int git_graph_reachable_from_any(
    git_repository* repo,
    const(git_oid)* commit,
    const(git_oid)* descendant_array,
    size_t length
);
