module git.sys.mempack;

import core.stdc.config;
alias size_t = c_ulong;

import git, git.sys;

extern (C):

int git_mempack_new(git_odb_backend** odbbe_out);
int git_mempack_write_thin_pack(git_odb_backend* backend, git_packbuilder* pb);
int git_mempack_dump(git_buf* pack, git_repository* repo, git_odb_backend* backend);
int git_mempack_reset(git_odb_backend* backend);
int git_mempack_object_count(size_t* count, git_odb_backend* backend);