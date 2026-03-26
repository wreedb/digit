module git.sys.remote;
import git, git.sys;

extern (C):

enum git_remote_capability_t
{
    tip_oid = (1 << 0),
    reachable_oid = (1 << 1),
    push_options = (1 << 2)
}

void git_remote_connect_options_dispose(git_remote_connect_options* opts);