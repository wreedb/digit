module git.proxy;

import core.stdc.config;
alias size_t = c_ulong;

import git.types, git.credential, git.cert;

extern (C):

enum git_proxy_t
{
    none = 0,
    automatic = 1,
    specified = 2
}


struct git_proxy_options
{
    uint vers;
    git_proxy_t type;
    const(char)* url;
    git_credential_acquire_cb credentials;
    git_transport_certificate_check_cb certificate_check;
    void* payload;
}

enum GIT_PROXY_OPTIONS_VERSION = 1;
int git_proxy_options_init(git_proxy_options* options, uint version_);