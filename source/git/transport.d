module git.transport;
import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

alias git_transport_message_cb = int function(const(char)* str, int len, void* payload);
alias git_transport_cb = int function(git_transport** tp_out, git_remote* owner, void* param);