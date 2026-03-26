module git.net;

import git.oid;

extern (C):

enum GIT_DEFAULT_PORT = "9418";

enum git_direction
{
    GIT_DIRECTION_FETCH = 0,
    GIT_DIRECTION_PUSH  = 1
}

alias GIT_DIRECTION_FETCH = git_direction.GIT_DIRECTION_FETCH;
alias GIT_DIRECTION_PUSH = git_direction.GIT_DIRECTION_PUSH;

struct git_remote_head
{
    int local;
    git_oid oid;
    git_oid loid;
    char* name;
    char* symref_target;
}
