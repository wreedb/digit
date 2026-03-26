module git.trace;
import core.stdc.config;
alias size_t = c_ulong;
import git;

extern (C):

enum git_trace_level_t
{
    NONE = 0,
    FATAL = 1,
    ERROR = 2,
    WARN = 3,
    INFO = 4,
    DEBUG = 5,
    TRACE = 6
}

alias git_trace_cb = void function(git_trace_level_t level, const(char)* msg);

int git_trace_set(git_trace_level_t level, git_trace_cb cb);

