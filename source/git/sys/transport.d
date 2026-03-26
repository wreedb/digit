module git.sys.transport;

import git, git.sys;

import core.stdc.config;
alias size_t = c_ulong;

extern (C):

struct git_fetch_negotiation
{
    const(git_remote_head*)* refs;
    size_t refs_len;
    git_oid* shallow_roots;
    size_t shallow_roots_len;
    int depth;
}

struct git_transport
{
    uint version_;

    int function(
        git_transport* tp,
        const(char)* url,
        int direction,
        const(git_remote_connect_options)* connect_opts
    ) connect;

    int function(
        git_transport* transport,
        const(git_remote_connect_options)* connect_opts
    ) set_connect_opts;

    int function(uint* capabilities, git_transport* transport) capabilities;

    int function(
        const(git_remote_head**)* remhead_out,
        size_t* size,
        git_transport* transport
    ) ls;

    int function(git_transport* transport, git_push* push) push;

    int function(
        git_transport* transport,
        git_repository* repo,
        const(git_fetch_negotiation)* fetch_data
    ) negotiate_fetch;

    int function(git_oidarray* oidarr_out, git_transport* transport) shallow_roots;

    int function(
        git_transport* transport,
        git_repository* repo,
        git_indexer_progress* stats
    ) download_pack;

    int function(git_transport* transport) is_connected;
    void function(git_transport* transport) cancel;
    int function(git_transport* transport) close;
    void function(git_transport* transport) free;
}

enum GIT_TRANSPORT_VERSION = 1;

int git_transport_init(git_transport* opts, uint version_);
int git_transport_new(git_transport** tp_out, git_remote* owner, const(char)* url);
int git_transport_ssh_with_paths(git_transport** tp_out, git_remote* owner, void* payload);

int git_transport_register(
    const(char)* prefix,
    git_transport_cb cb,
    void* param
);

int git_transport_unregister(const(char)* prefix);
int git_transport_dummy(git_transport** tp_out, git_remote* owner, void* payload);
int git_transport_local(git_transport** tp_out, git_remote* owner, void* payload);
int git_transport_smart(git_transport** tp_out, git_remote* owner, void* payload);
int git_transport_smart_certificate_check(git_transport* tp, git_cert* cert, int valid, const(char)* hostname);
int git_transport_smart_credentials(git_credential** cred_out, git_transport* transport, const(char)* user, int methods);

int git_transport_remote_connect_options(
    git_remote_connect_options* remconnopts_out,
    git_transport* transport
);

enum git_smart_service_t
{
    uploadpack_ls = 1,
    uploadpack = 2,
    receivepack_ls = 3,
    receivepack = 4
}

struct git_smart_subtransport_stream
{
    git_smart_subtransport* subtransport;

    int function(
        git_smart_subtransport_stream* stream,
        char* buffer,
        size_t buf_size,
        size_t* bytes_read
    ) read;

    int function(
        git_smart_subtransport_stream* stream,
        const(char)* buffer,
        size_t len
    ) write;

    void function(git_smart_subtransport_stream* stream) free;
}

struct git_smart_subtransport
{
    int function(
        git_smart_subtransport_stream** subtpstream_out,
        git_smart_subtransport* transport,
        const(char)* url,
        git_smart_service_t action
    ) action;

    int function(git_smart_subtransport* transport) close;
    void function(git_smart_subtransport* transport) free;
}

alias git_smart_subtransport_cb = int function(
    git_smart_subtransport** sstp_out,
    git_transport* owner,
    void* param
);

struct git_smart_subtransport_definition
{
    git_smart_subtransport_cb callback;
    uint rpc;
    void* param;
}

int git_smart_subtransport_http(
    git_smart_subtransport** sstp_out,
    git_transport* owner,
    void* param
);

int git_smart_subtransport_git(
    git_smart_subtransport** sstp_out,
    git_transport* owner,
    void* param
);

int git_smart_subtransport_ssh(
    git_smart_subtransport** sstp_out,
    git_transport* owner,
    void* param
);