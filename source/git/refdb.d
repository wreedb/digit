module git.refdb;

import git.types, git.repository;

extern (C):

int git_refdb_new(git_refdb** rdb_out, git_repository* repo);
int git_refdb_open(git_refdb** rdb_out, git_repository* repo);
int git_refdb_compress(git_refdb* refdb);
void git_refdb_free(git_refdb* refdb);