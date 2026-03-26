module git.index;

import core.stdc.config;

alias size_t = c_ulong;

import
    git.types,
    git.oid,
    git.repository,
    git.strarray;
    

extern (C):

struct git_index_time
{
    int seconds;
    uint nanoseconds;
}

struct git_index_entry
{
    git_index_time ctime;
    git_index_time mtime;

    uint dev;
    uint ino;
    uint mode;
    uint uid;
    uint gid;
    uint file_size;
    git_oid id;
    ushort flags;
    ushort flags_extended;
    const(char)* path;
}

enum GIT_INDEX_ENTRY_NAMEMASK = 0x0fff;
enum GIT_INDEX_ENTRY_STAGEMASK = 0x3000;
enum GIT_INDEX_ENTRY_STAGESHIFT = 12;

enum git_index_entry_flag_t
{
    GIT_INDEX_ENTRY_EXTENDED = 0x4000,
    GIT_INDEX_ENTRY_VALID = 0x8000
}

extern (D) auto GIT_INDEX_ENTRY_STAGE(T)(auto ref T E)
{
    return (E.flags & GIT_INDEX_ENTRY_STAGEMASK) >> GIT_INDEX_ENTRY_STAGESHIFT;
}

enum git_index_entry_extended_flag_t
{
    GIT_INDEX_ENTRY_INTENT_TO_ADD = 1 << 13,
    GIT_INDEX_ENTRY_SKIP_WORKTREE = 1 << 14,
    GIT_INDEX_ENTRY_EXTENDED_FLAGS = GIT_INDEX_ENTRY_INTENT_TO_ADD | GIT_INDEX_ENTRY_SKIP_WORKTREE,
    GIT_INDEX_ENTRY_UPTODATE = 1 << 2
}

enum git_index_capability_t
{
    GIT_INDEX_CAPABILITY_IGNORE_CASE = 1,
    GIT_INDEX_CAPABILITY_NO_FILEMODE = 2,
    GIT_INDEX_CAPABILITY_NO_SYMLINKS = 4,
    GIT_INDEX_CAPABILITY_FROM_OWNER = -1
}

alias git_index_matched_path_cb = int function(
    const(char)* path,
    const(char)* matched_pathspec,
    void* payload);

enum git_index_add_option_t
{
    GIT_INDEX_ADD_DEFAULT = 0,
    GIT_INDEX_ADD_FORCE = 1u << 0,
    GIT_INDEX_ADD_DISABLE_PATHSPEC_MATCH = 1u << 1,
    GIT_INDEX_ADD_CHECK_PATHSPEC = 1u << 2
}

enum git_index_stage_t
{
    GIT_INDEX_STAGE_ANY = -1,
    GIT_INDEX_STAGE_NORMAL = 0,
    GIT_INDEX_STAGE_ANCESTOR = 1,
    GIT_INDEX_STAGE_OURS = 2,
    GIT_INDEX_STAGE_THEIRS = 3
}

int git_index_open(git_index** index_out, const(char)* index_path);

int git_index_new(git_index** index_out);

void git_index_free(git_index* index);

git_repository* git_index_owner(const(git_index)* index);

int git_index_caps(const(git_index)* index);

int git_index_set_caps(git_index* index, int caps);

uint git_index_version(git_index* index);

int git_index_set_version(git_index* index, uint version_);

int git_index_read(git_index* index, int force);

int git_index_write(git_index* index);

const(char)* git_index_path(const(git_index)* index);

const(git_oid)* git_index_checksum(git_index* index);

int git_index_read_tree(git_index* index, const(git_tree)* tree);

int git_index_write_tree(git_oid* oid_out, git_index* index);

int git_index_write_tree_to(git_oid* oid_out, git_index* index, git_repository* repo);

size_t git_index_entrycount(const(git_index)* index);

int git_index_clear(git_index* index);

const(git_index_entry)* git_index_get_byindex(git_index* index, size_t n);

const(git_index_entry)* git_index_get_bypath(
    git_index* index,
    const(char)* path,
    int stage
);

int git_index_remove(git_index* index, const(char)* path, int stage);

int git_index_remove_directory(git_index* index, const(char)* dir, int stage);

int git_index_add(git_index* index, const(git_index_entry)* source_entry);

int git_index_entry_stage(const(git_index_entry)* entry);

int git_index_entry_is_conflict(const(git_index_entry)* entry);

int git_index_iterator_new(git_index_iterator** iterator_out, git_index* index);

int git_index_iterator_next(
    const(git_index_entry*)* index_out,
    git_index_iterator* iterator
);

void git_index_iterator_free(git_index_iterator* iterator);

int git_index_add_bypath(git_index* index, const(char)* path);

int git_index_add_from_buffer(
    git_index* index,
    const(git_index_entry)* entry,
    const(void)* buffer,
    size_t len
);

int git_index_remove_bypath(git_index* index, const(char)* path);

int git_index_add_all(
    git_index* index,
    const(git_strarray)* pathspec,
    uint flags,
    git_index_matched_path_cb callback,
    void* payload
);

int git_index_remove_all(
    git_index* index,
    const(git_strarray)* pathspec,
    git_index_matched_path_cb callback,
    void* payload
);

int git_index_update_all(
    git_index* index,
    const(git_strarray)* pathspec,
    git_index_matched_path_cb callback,
    void* payload
);

int git_index_find(size_t* at_pos, git_index* index, const(char)* path);
int git_index_find_prefix(size_t* at_pos, git_index* index, const(char)* prefix);

int git_index_conflict_add(
    git_index* index,
    const(git_index_entry)* ancestor_entry,
    const(git_index_entry)* our_entry,
    const(git_index_entry)* their_entry
);

int git_index_conflict_get(
    const(git_index_entry*)* ancestor_out,
    const(git_index_entry*)* our_out,
    const(git_index_entry*)* their_out,
    git_index* index,
    const(char)* path
);

int git_index_conflict_remove(git_index* index, const(char)* path);
int git_index_conflict_cleanup(git_index* index);
int git_index_has_conflicts(const(git_index)* index);

int git_index_conflict_iterator_new(
    git_index_conflict_iterator** iterator_out,
    git_index* index
);

int git_index_conflict_next(
    const(git_index_entry*)* ancestor_out,
    const(git_index_entry*)* our_out,
    const(git_index_entry*)* their_out,
    git_index_conflict_iterator* iterator
);

void git_index_conflict_iterator_free(git_index_conflict_iterator* iterator);