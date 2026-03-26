module git.sys.path;

import core.stdc.config;
alias size_t = c_ulong;

import git, git.sys;

extern (C):

enum git_path_gitfile
{
    gitignore = 0,
    gitmodules = 1,
    gitattributes = 2
}

enum git_path_fs
{
    generic = 0,
    ntfs = 1,
    hfs = 2
}

int git_path_is_gitfile(const(char)* path, size_t pathlen, git_path_gitfile gitfile, git_path_fs fs);