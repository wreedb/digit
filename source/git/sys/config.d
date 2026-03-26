module git.sys.config;

import core.stdc.config;
alias size_t = c_ulong;

import git, git.sys;

extern (C):

struct git_config_backend_entry
{
    git_config_entry entry;

    void function(git_config_backend_entry* entry) free;
}

struct git_config_iterator
{
    git_config_backend* backend;
    uint flags;
    int function(git_config_backend_entry** entry, git_config_iterator* iter) next;
    void function(git_config_iterator* iter) free;
}

struct git_config_backend
{
    uint version_;
    int readonly;
    git_config* cfg;

    int function(git_config_backend*, git_config_level_t level, const(git_repository)* repo) open;
    int function(git_config_backend*, const(char)* key, git_config_backend_entry** entry) get;
    int function(git_config_backend*, const(char)* key, const(char)* value) set;
    int function(git_config_backend* cfg, const(char)* name, const(char)* regexp, const(char)* value) set_multivar;
    int function(git_config_backend*, const(char)* key) del;
    int function(git_config_backend*, const(char)* key, const(char)* regexp) del_multivar;
    int function(git_config_iterator**, git_config_backend*) iterator;
    int function(git_config_backend**, git_config_backend*) snapshot;
    int function(git_config_backend*) lock;
    int function(git_config_backend*, int success) unlock;
    void function(git_config_backend*) free;
}

enum GIT_CONFIG_BACKEND_VERSION = 1;

int git_config_init_backend(git_config_backend* backend, uint version_);

int git_config_add_backend(
    git_config* cfg,
    git_config_backend* file,
    git_config_level_t level,
    const(git_repository)* repo,
    int force
);

struct git_config_backend_memory_options
{
    uint version_;
    const(char)* backend_type;
    const(char)* origin_path;
}

enum GIT_CONFIG_BACKEND_MEMORY_OPTIONS_VERSION = 1;

int git_config_backend_from_string(
    git_config_backend** cfgbe_out,
    const(char)* cfg,
    size_t len,
    git_config_backend_memory_options* opts
);

int git_config_backend_from_values(
    git_config_backend** cfgbe_out,
    const(char*)* values,
    size_t len,
    git_config_backend_memory_options* opts
);
