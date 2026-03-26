module git.config;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

enum git_config_level_t
{
    PROGRAMDATA = 1,
    SYSTEM = 2,
    XDG = 3,
    GLOBAL = 4,
    LOCAL = 5,
    WORKTREE = 6,
    APP = 7,
    HIGHEST_LEVEL = -1
}

struct git_config_entry
{
    const(char)* name;
    const(char)* value;
    const(char)* backend_type;
    const(char)* origin_path;
    uint include_depth;
    git_config_level_t level;
}

void git_config_entry_free(git_config_entry* entry);

alias git_config_foreach_cb = int function(const(git_config_entry)* entry, void* payload);

struct git_config_iterator;

enum git_configmap_t
{
    FALSE = 0,
    TRUE = 1,
    INT32 = 2,
    STRING = 3
}

struct git_configmap
{
    git_configmap_t type;
    const(char)* str_match;
    int map_value;
}

int git_config_find_global(git_buf* out_);
int git_config_find_xdg(git_buf* out_);
int git_config_find_system(git_buf* out_);
int git_config_find_programdata(git_buf* out_);
int git_config_open_default(git_config** out_);
int git_config_new(git_config** out_);

int git_config_add_file_ondisk(
    git_config* cfg,
    const(char)* path,
    git_config_level_t level,
    const(git_repository)* repo,
    int force
);

int git_config_open_ondisk(git_config** out_, const(char)* path);

int git_config_open_level(
    git_config** out_,
    const(git_config)* parent,
    git_config_level_t level
);

int git_config_open_global(git_config** out_, git_config* config);

int git_config_set_writeorder(
    git_config* cfg,
    git_config_level_t* levels,
    size_t len);

int git_config_snapshot(git_config** out_, git_config* config);

void git_config_free(git_config* cfg);

int git_config_get_entry(
    git_config_entry** out_,
    const(git_config)* cfg,
    const(char)* name);

int git_config_get_int32(int* out_, const(git_config)* cfg, const(char)* name);

int git_config_get_int64(long* out_, const(git_config)* cfg, const(char)* name);

int git_config_get_bool(int* out_, const(git_config)* cfg, const(char)* name);

int git_config_get_path(git_buf* out_, const(git_config)* cfg, const(char)* name);

int git_config_get_string(const(char*)* out_, const(git_config)* cfg, const(char)* name);

int git_config_get_string_buf(git_buf* out_, const(git_config)* cfg, const(char)* name);

int git_config_get_multivar_foreach(const(git_config)* cfg, const(char)* name, const(char)* regexp, git_config_foreach_cb callback, void* payload);

int git_config_multivar_iterator_new(git_config_iterator** out_, const(git_config)* cfg, const(char)* name, const(char)* regexp);

int git_config_next(git_config_entry** entry, git_config_iterator* iter);

void git_config_iterator_free(git_config_iterator* iter);

int git_config_set_int32(git_config* cfg, const(char)* name, int value);

int git_config_set_int64(git_config* cfg, const(char)* name, long value);

int git_config_set_bool(git_config* cfg, const(char)* name, int value);

int git_config_set_string(git_config* cfg, const(char)* name, const(char)* value);

int git_config_set_multivar(git_config* cfg, const(char)* name, const(char)* regexp, const(char)* value);

int git_config_delete_entry(git_config* cfg, const(char)* name);

int git_config_delete_multivar(git_config* cfg, const(char)* name, const(char)* regexp);

int git_config_foreach(
    const(git_config)* cfg,
    git_config_foreach_cb callback,
    void* payload);

int git_config_iterator_new(git_config_iterator** out_, const(git_config)* cfg);

int git_config_iterator_glob_new(git_config_iterator** out_, const(git_config)* cfg, const(char)* regexp);

int git_config_foreach_match(
    const(git_config)* cfg,
    const(char)* regexp,
    git_config_foreach_cb callback,
    void* payload);

int git_config_get_mapped(
    int* out_,
    const(git_config)* cfg,
    const(char)* name,
    const(git_configmap)* maps,
    size_t map_n);

int git_config_lookup_map_value(
    int* out_,
    const(git_configmap)* maps,
    size_t map_n,
    const(char)* value);

int git_config_parse_bool(int* out_, const(char)* value);

int git_config_parse_int32(int* out_, const(char)* value);

int git_config_parse_int64(long* out_, const(char)* value);

int git_config_parse_path(git_buf* out_, const(char)* value);

int git_config_backend_foreach_match(
    git_config_backend* backend,
    const(char)* regexp,
    git_config_foreach_cb callback,
    void* payload);

int git_config_lock(git_transaction** tx, git_config* cfg);