module git.remote;

import git;

import core.stdc.config : c_ulong;

alias size_t = c_ulong;

extern (C):

int git_remote_create(
    git_remote** remote_out,
    git_repository* repo,
    const(char)* name,
    const(char)* url
);

// enum git_remote_redirect_t
// {
//     GIT_REMOTE_REDIRECT_NONE    = 1 << 0,
//     GIT_REMOTE_REDIRECT_INITIAL = 1 << 1,
//     GIT_REMOTE_REDIRECT_ALL     = 1 << 2,
// }
enum git_remote_redirect_t
{
    none = 1 << 0,
    initial = 1 << 1,
    all = 1 << 2
}

// alias GIT_REMOTE_REDIRECT_NONE = git_remote_redirect_t.GIT_REMOTE_REDIRECT_NONE;
// alias GIT_REMOTE_REDIRECT_INITIAL = git_remote_redirect_t.GIT_REMOTE_REDIRECT_INITIAL;
// alias GIT_REMOTE_REDIRECT_ALL = git_remote_redirect_t.GIT_REMOTE_REDIRECT_ALL;

enum git_remote_create_flags
{
    skip_insteadof         = 1 << 0,
    skip_default_fetchspec = 1 << 1
}

// alias GIT_REMOTE_CREATE_SKIP_INSTEADOF = git_remote_create_flags.GIT_REMOTE_CREATE_SKIP_INSTEADOF;
// alias GIT_REMOTE_CREATE_SKIP_DEFAULT_FETCHSPEC = git_remote_create_flags.GIT_REMOTE_CREATE_SKIP_DEFAULT_FETCHSPEC;

enum git_remote_update_flags
{
    fetchhead        = 1 << 0,
    report_unchanged = 1 << 1
}

// alias GIT_REMOTE_UPDATE_FETCHHEAD = git_remote_update_flags.GIT_REMOTE_UPDATE_FETCHHEAD;
// alias GIT_REMOTE_UPDATE_REPORT_UNCHANGED = git_remote_update_flags.GIT_REMOTE_UPDATE_REPORT_UNCHANGED;

struct git_remote_create_options
{
    uint vers;
    git_repository* repo;
    const(char)* name;
    const(char)* fetch_spec;
    uint flags;
}

enum GIT_REMOTE_CREATE_OPTIONS_VERSION = 1;

int git_remote_create_options_init(git_remote_create_options* options, uint vers);

int git_remote_create_with_opts(
    git_remote** remote_out,
    const(char)* url,
    const(git_remote_create_options)* opts
);

int git_remote_create_with_fetchspec(
    git_remote** remote_out,
    git_repository* repo,
    const(char)* name,
    const(char)* url,
    const(char)* fetch
);

int git_remote_create_anonymous(
    git_remote** remote_out,
    git_repository* repo,
    const(char)* url
);

int git_remote_create_detached(git_remote** remote_out, const(char)* url);
int git_remote_lookup(git_remote** remote_out, git_repository* repo, const(char)* name);
int git_remote_dup(git_remote** dest, git_remote* source);

git_repository* git_remote_owner(const(git_remote)* remote);
const(char)* git_remote_name(const(git_remote)* remote);
const(char)* git_remote_url(const(git_remote)* remote);
const(char)* git_remote_pushurl(const(git_remote)* remote);

int git_remote_set_url(git_repository* repo, const(char)* remote, const(char)* url);
int git_remote_set_pushurl(git_repository* repo, const(char)* remote, const(char)* url);
int git_remote_set_instance_url(git_remote* remote, const(char)* url);
int git_remote_set_instance_pushurl(git_remote* remote, const(char)* url);
int git_remote_add_fetch(git_repository* repo, const(char)* remote, const(char)* refspec);
int git_remote_get_fetch_refspecs(git_strarray* array, const(git_remote)* remote);
int git_remote_add_push(git_repository* repo, const(char)* remote, const(char)* refspec);
int git_remote_get_push_refspecs(git_strarray* sarr, const(git_remote)* remote);

size_t git_remote_refspec_count(const(git_remote)* remote);
const(git_refspec)* git_remote_get_refspec(const(git_remote)* remote, size_t n);
int git_remote_ls(const(git_remote_head**)* remote_head_out, size_t* size, git_remote* remote);
int git_remote_connected(const(git_remote)* remote);
int git_remote_stop(git_remote* remote);

int git_remote_disconnect(git_remote* remote);

void git_remote_free(git_remote* remote);

int git_remote_list(git_strarray* sarr_out, git_repository* repo);

enum git_remote_completion_t
{
    DOWNLOAD = 0,
    INDEXING = 1,
    ERROR    = 2
}

// alias GIT_REMOTE_COMPLETION_DOWNLOAD = git_remote_completion_t.GIT_REMOTE_COMPLETION_DOWNLOAD;
// alias GIT_REMOTE_COMPLETION_INDEXING = git_remote_completion_t.GIT_REMOTE_COMPLETION_INDEXING;
// alias GIT_REMOTE_COMPLETION_ERROR    = git_remote_completion_t.GIT_REMOTE_COMPLETION_ERROR;

alias git_push_transfer_progress_cb = int function(
    uint current,
    uint total,
    size_t bytes,
    void* payload
);

struct git_push_update
{
    char* sourceRefName;
    char* destinationRefName;
    git_oid sourceOid;
    git_oid destinationOid;
}

alias git_push_negotiation = int function(
    const(git_push_update*)* updates,
    size_t len,
    void* payload
);

alias git_push_update_reference_cb = int function(const(char)* refname, const(char)* status, void* data);
alias git_url_resolve_cb = int function(git_buf* url_resolved, const(char)* url, int direction, void* payload);
alias git_remote_ready_cb = int function(git_remote* remote, int direction, void* payload);

struct git_remote_callbacks
{
    uint version_;

    alias git_transport_message_cb = int function(const(char)* str, int len, void* payload);
    git_transport_message_cb sideband_progress;

    int function(git_remote_completion_t type, void* data) completion;

    git_credential_acquire_cb credentials;

    alias git_transport_certificate_check_cb = int function(git_cert* cert, int valid, const(char)* host, void* payload);
    git_transport_certificate_check_cb certificate_check;

    alias git_indexer_progress_cb = int function(const(git_indexer_progress)* stats, void* payload);
    git_indexer_progress_cb transfer_progress;

    alias update_tips_cb = int function(
        const(char)* refname,
        const(git_oid)* a,
        const(git_oid)* b,
        void* data
    );

    update_tips_cb update_tips;

    alias git_packbuilder_progress = int function(
        int stage,
        uint current,
        uint total,
        void* payload
    );

    git_packbuilder_progress pack_progress;
    git_push_transfer_progress_cb push_transfer_progress;
    git_push_update_reference_cb push_update_reference;
    git_push_negotiation push_negotiation;

    alias git_transport_cb = int function(git_transport** tp_out, git_remote* owner, void* param);
    git_transport_cb transport;

    git_remote_ready_cb remote_ready;

    void* payload;

    git_url_resolve_cb resolve_url;

    alias update_refs_cb = int function(
        const(char)* refname,
        const(git_oid)* a,
        const(git_oid)* b,
        git_refspec* spec,
        void* data
    );

    update_refs_cb update_refs;
}

enum GIT_REMOTE_CALLBACKS_VERSION = 1;

int git_remote_init_callbacks(git_remote_callbacks* options, uint version_);

enum git_fetch_prune_t
{
    UNSPECIFIED = 0,
    NORMAL = 1,
    NO_PRUNE = 2
}

// alias GIT_FETCH_PRUNE_UNSPECIFIED = git_fetch_prune_t.GIT_FETCH_PRUNE_UNSPECIFIED;
// alias GIT_FETCH_PRUNE = git_fetch_prune_t.GIT_FETCH_PRUNE;
// alias GIT_FETCH_NO_PRUNE = git_fetch_prune_t.GIT_FETCH_NO_PRUNE;

enum git_remote_autotag_option_t
{
    UNSPECIFIED = 0,
    AUTO        = 1,
    NONE        = 2,
    ALL         = 3
}

enum git_fetch_depth_t
{
    FULL      = 0,
    UNSHALLOW = 2147483647
}

// alias GIT_FETCH_DEPTH_FULL      = git_fetch_depth_t.GIT_FETCH_DEPTH_FULL;
// alias GIT_FETCH_DEPTH_UNSHALLOW = git_fetch_depth_t.GIT_FETCH_DEPTH_UNSHALLOW;

struct git_fetch_options
{
    int version_;
    git_remote_callbacks callbacks;
    git_fetch_prune_t prune;
    uint update_fetchhead;
    git_remote_autotag_option_t download_tags;
    git_proxy_options proxy_opts;
    int depth;
    git_remote_redirect_t follow_redirects;
    git_strarray custom_headers;
}

enum GIT_FETCH_OPTIONS_VERSION = 1;

int git_fetch_options_init(git_fetch_options* options, uint version_);

struct git_push_options
{
    uint version_;
    uint pb_parallelism;
    git_remote_callbacks callbacks;
    git_proxy_options proxy_opts;
    git_remote_redirect_t follow_redirects;
    git_strarray custom_headers;
    git_strarray remote_push_options;
}

enum GIT_PUSH_OPTIONS_VERSION = 1;

int git_push_options_init(git_push_options* options, uint version_);

struct git_remote_connect_options
{
    uint version_;
    git_remote_callbacks callbacks;
    git_proxy_options proxy_opts;
    git_remote_redirect_t follow_redirects;
    git_strarray custom_headers;
}

enum GIT_REMOTE_CONNECT_OPTIONS_VERSION = 1;

int git_remote_connect_options_init(
    git_remote_connect_options* opts,
    uint version_
);

int git_remote_connect(
    git_remote* remote,
    git_direction direction,
    const(git_remote_callbacks)* callbacks,
    const(git_proxy_options)* proxy_opts,
    const(git_strarray)* custom_headers
);

int git_remote_connect_ext(
    git_remote* remote,
    git_direction direction,
    const(git_remote_connect_options)* options
);

int git_remote_download(
    git_remote* remote,
    const(git_strarray)* refspecs,
    const(git_fetch_options)* options
);

int git_remote_upload(
    git_remote* remote,
    const(git_strarray)* refspecs,
    const(git_push_options)* options
);

int git_remote_update_tips(
    git_remote* remote,
    const(git_remote_callbacks)* callbacks,
    uint update_flags,
    git_remote_autotag_option_t download_tags,
    const(char)* reflog_message
);

int git_remote_fetch(
    git_remote* remote,
    const(git_strarray)* refspecs,
    const(git_fetch_options)* options,
    const(char)* reflog_message
);

int git_remote_prune(
    git_remote* remote,
    const(git_remote_callbacks)* callbacks
);

int git_remote_push(
    git_remote* remote,
    const(git_strarray)* refspecs,
    const(git_push_options)* options
);

const(git_indexer_progress)* git_remote_stats(git_remote* remote);
git_remote_autotag_option_t git_remote_autotag(const(git_remote)* remote);
int git_remote_set_autotag(git_repository* repo, const(char)* remote, git_remote_autotag_option_t value);
int git_remote_prune_refs(const(git_remote)* remote);

int git_remote_rename(
    git_strarray* problems,
    git_repository* repo,
    const(char)* name,
    const(char)* new_name
);

int git_remote_name_is_valid(int* valid, const(char)* remote_name);
int git_remote_delete(git_repository* repo, const(char)* name);
int git_remote_default_branch(git_buf* buf, git_remote* remote);
