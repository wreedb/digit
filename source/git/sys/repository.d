module git.sys.repository;

import git, git.sys;

extern (C):

int git_repository_new(git_repository** repo_out);
int git_repository__cleanup(git_repository* repo);

int git_repository_reinit_filesystem(
    git_repository* repo,
    int recurse_submodules
);

int git_repository_set_config(git_repository* repo, git_config* config);
int git_repository_set_odb(git_repository* repo, git_odb* odb);
int git_repository_set_refdb(git_repository* repo, git_refdb* refdb);
int git_repository_set_index(git_repository* repo, git_index* index);
int git_repository_set_bare(git_repository* repo);
int git_repository_submodule_cache_all(git_repository* repo);
int git_repository_submodule_cache_clear(git_repository* repo);