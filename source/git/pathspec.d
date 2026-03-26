module git.pathspec;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

struct git_pathspec;
struct git_pathspec_match_list;

enum git_pathspec_flag_t : uint
{
    normal = 0,
    ignore_case = (1u << 0),
    use_case = (1u << 1),
    no_glob = (1u << 2),
    no_match_error = (1u << 3),
    find_failures = (1u << 4),
    failures_only = (1u << 5)
}

int git_pathspec_new(git_pathspec** ps_out, const(git_strarray)* pathspec);
void git_pathspec_free(git_pathspec* ps);

int git_pathspec_matches_path(
    const(git_pathspec)* ps,
    uint flags,
    const(char)* path
);

int git_pathspec_match_workdir(
    git_pathspec_match_list** psml_out,
    git_repository* repo,
    uint flags,
    git_pathspec* ps
);

int git_pathspec_match_index(
    git_pathspec_match_list** psml_out,
    git_index* index,
    uint flags,
    git_pathspec* ps
);

int git_pathspec_match_tree(
    git_pathspec_match_list** psml_out,
    git_tree* tree,
    uint flags,
    git_pathspec* ps
);

int git_pathspec_match_diff(
    git_pathspec_match_list** psml_out,
    git_diff* diff,
    uint flags,
    git_pathspec* ps
);

void git_pathspec_match_list_free(git_pathspec_match_list* m);
size_t git_pathspec_match_list_entrycount(const(git_pathspec_match_list)* m);
const(char)* git_pathspec_match_list_entry(const(git_pathspec_match_list)* m, size_t pos);
const(git_diff_delta)* git_pathspec_match_list_diff_entry(const(git_pathspec_match_list)* m, size_t pos);
size_t git_pathspec_match_list_failed_entrycount(const(git_pathspec_match_list)* m);
const(char)* git_pathspec_match_list_failed_entry(const(git_pathspec_match_list)* m, size_t pos);