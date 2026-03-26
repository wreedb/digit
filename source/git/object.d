module git.object;

import git.buffer : git_buf;
import git.types : git_object, git_object_t, git_repository;
import git.oid : git_oid;

import core.stdc.stdint : UINT64_MAX;
import core.stdc.config : c_ulong;

alias size_t = c_ulong;

extern (C):

enum GIT_OBJECT_SIZE_MAX = UINT64_MAX;

int git_object_lookup(
    git_object** obj,
    git_repository* repo,
    const(git_oid)* id,
    git_object_t type
);

int git_object_lookup_prefix(
    git_object** obj_out,
    git_repository* repo,
    const(git_oid)* id,
    size_t len,
    git_object_t type
);

int git_object_lookup_bypath(
    git_object** obj_out,
    const(git_object)* treeish,
    const(char)* path,
    git_object_t type
);

const(git_oid)* git_object_id(const(git_object)* obj);

int git_object_short_id(git_buf* buf, const(git_object)* obj);

git_object_t git_object_type(const(git_object)* obj);

git_repository* git_object_owner(const(git_object)* obj);

void git_object_free(git_object* object);

const(char)* git_object_type2string(git_object_t type);

git_object_t git_object_string2type(const(char)* str);

int git_object_typeisloose(git_object_t type);

int git_object_peel(
    git_object** peeled,
    const(git_object)* obj,
    git_object_t target_type
);

int git_object_dup(git_object** dest, git_object* source);

int git_object_rawcontent_is_valid(
    int* valid,
    const(char)* buf,
    size_t len,
    git_object_t obj_type);