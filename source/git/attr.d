module git.attr;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

extern (D) auto GIT_ATTR_IS_TRUE(T)(auto ref T attr)
{
    return git_attr_value(attr) == git_attr_value_t.GIT_ATTR_VALUE_TRUE;
}

extern (D) auto GIT_ATTR_IS_FALSE(T)(auto ref T attr)
{
    return git_attr_value(attr) == git_attr_value_t.GIT_ATTR_VALUE_FALSE;
}

extern (D) auto GIT_ATTR_IS_UNSPECIFIED(T)(auto ref T attr)
{
    return git_attr_value(attr) == git_attr_value_t.GIT_ATTR_VALUE_UNSPECIFIED;
}

extern (D) auto GIT_ATTR_HAS_VALUE(T)(auto ref T attr)
{
    return git_attr_value(attr) == git_attr_value_t.GIT_ATTR_VALUE_STRING;
}

enum git_attr_value_t
{
    UNSPECIFIED = 0,
    TRUE = 1,
    FALSE = 2,
    STRING = 3
}

git_attr_value_t git_attr_value(const(char)* attr);

enum GIT_ATTR_CHECK_FILE_THEN_INDEX = 0;
enum GIT_ATTR_CHECK_INDEX_THEN_FILE = 1;
enum GIT_ATTR_CHECK_INDEX_ONLY = 2;
enum GIT_ATTR_CHECK_NO_SYSTEM = 1 << 2;
enum GIT_ATTR_CHECK_INCLUDE_HEAD = 1 << 3;
enum GIT_ATTR_CHECK_INCLUDE_COMMIT = 1 << 4;

enum git_attr_check_t : uint
{
    file_then_index = GIT_ATTR_CHECK_FILE_THEN_INDEX,
    index_then_file = GIT_ATTR_CHECK_INDEX_THEN_FILE,
    index_only = GIT_ATTR_CHECK_INDEX_ONLY,
    include_head = GIT_ATTR_CHECK_INCLUDE_HEAD,
    include_commit = GIT_ATTR_CHECK_INCLUDE_COMMIT
}

struct git_attr_options
{
    uint vers;
    uint flags;
    git_oid* commit_id;
    git_oid attr_commit_id;
}

enum GIT_ATTR_OPTIONS_VERSION = 1;

int git_attr_get(
    const(char*)* value_out,
    git_repository* repo,
    uint flags,
    const(char)* path,
    const(char)* name
);

int git_attr_get_ext(
    const(char*)* value_out,
    git_repository* repo,
    git_attr_options* opts,
    const(char)* path,
    const(char)* name
);

int git_attr_get_many(
    const(char*)* values_out,
    git_repository* repo,
    uint flags,
    const(char)* path,
    size_t num_attr,
    const(char*)* names
);

int git_attr_get_many_ext(
    const(char*)* values_out,
    git_repository* repo,
    git_attr_options* opts,
    const(char)* path,
    size_t num_attr,
    const(char*)* names
);

alias git_attr_foreach_cb = int function(const(char)* name, const(char)* value, void* payload);

int git_attr_foreach(
    git_repository* repo,
    uint flags,
    const(char)* path,
    git_attr_foreach_cb callback,
    void* payload
);

int git_attr_foreach_ext(
    git_repository* repo,
    git_attr_options* opts,
    const(char)* path,
    git_attr_foreach_cb callback,
    void* payload
);

int git_attr_cache_flush(git_repository* repo);

int git_attr_add_macro(
    git_repository* repo,
    const(char)* name,
    const(char)* values
);
