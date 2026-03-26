module git.strarray;
import git.common;

import core.stdc.config;

alias size_t = c_ulong;

extern (C):

struct git_strarray
{
   char** strings;
   size_t count;
}

void git_strarray_dispose(git_strarray* sa);