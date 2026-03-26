module git.merge;

import core.stdc.config;
import git;

alias size_t = c_ulong;

extern (C):

struct git_merge_file_input
{
    uint version_;
    const(char)* ptr;
    size_t size;
    const(char)* path;
    uint mode;
}

enum GIT_MERGE_FILE_INPUT_VERSION = 1;

int git_merge_file_input_init(git_merge_file_input* opts, uint version_);

enum git_merge_flag_t
{
    find_renames = 1 << 0,
    fail_on_conflict = 1 << 1,
    skip_reuc = 1 << 2,
    no_recursive = 1 << 3,
    virtual_base = 1 << 4
}

enum git_merge_file_favor_t
{
    NORMAL = 0,
    OURS = 1,
    THEIRS = 2,
    UNION = 3
}

enum git_merge_file_flag_t
{
    normal = 0,
    style_merge = 1 << 0,
    style_diff3 = 1 << 1,
    simplify_alnum = 1 << 2,
    ignore_whitespace = 1 << 3,
    ignore_whitespace_change = 1 << 4,
    ignore_whitespace_eol = 1 << 5,
    diff_patience = 1 << 6,
    diff_minimal = 1 << 7,
    style_zdiff3 = 1 << 8,
    accept_conflicts = 1 << 9
}

enum GIT_MERGE_CONFLICT_MARKER_SIZE = 7;

struct git_merge_file_options
{
    uint version_;
    const(char)* ancestor_label;
    const(char)* our_label;
    const(char)* their_label;
    git_merge_file_favor_t favor;
    uint flags;
    ushort marker_size;
}

enum GIT_MERGE_FILE_OPTIONS_VERSION = 1;

int git_merge_file_options_init(git_merge_file_options* opts, uint version_);

struct git_merge_file_result
{
    uint automergeable;
    const(char)* path;
    uint mode;
    const(char)* ptr;
    size_t len;
}

struct git_merge_options
{
    uint version_;
    uint flags;
    uint rename_threshold;
    uint target_limit;
    git_diff_similarity_metric* metric;
    uint recursion_limit;
    const(char)* default_driver;
    git_merge_file_favor_t file_favor;
    uint file_flags;
}

enum GIT_MERGE_OPTIONS_VERSION = 1;

int git_merge_options_init(git_merge_options* opts, uint version_);

enum git_merge_analysis_t
{
    none = 0,
    normal = 1 << 0,
    up_to_date = 1 << 1,
    fastforward = 1 << 2,
    unborn = 1 << 3
}

enum git_merge_preference_t
{
    none = 0,
    no_fastforward = 1 << 0,
    fastforward_only = 1 << 1
}

int git_merge_analysis(
    git_merge_analysis_t* analysis_out,
    git_merge_preference_t* preference_out,
    git_repository* repo,
    const(git_annotated_commit*)* their_heads,
    size_t their_heads_len
);

int git_merge_analysis_for_ref(
    git_merge_analysis_t* analysis_out,
    git_merge_preference_t* preference_out,
    git_repository* repo,
    git_reference* our_ref,
    const(git_annotated_commit*)* their_heads,
    size_t their_heads_len
);

int git_merge_base(
    git_oid* oid_out,
    git_repository* repo,
    const(git_oid)* one,
    const(git_oid)* two
);

int git_merge_bases(
    git_oidarray* oidarr_out,
    git_repository* repo,
    const(git_oid)* one,
    const(git_oid)* two
);

int git_merge_base_many(
    git_oid* oid_out,
    git_repository* repo,
    size_t length,
    const(git_oid)* input_array
);

int git_merge_bases_many(
    git_oidarray* oidarr_out,
    git_repository* repo,
    size_t length,
    const(git_oid)* input_array
);

int git_merge_base_octopus(
    git_oid* oid_out,
    git_repository* repo,
    size_t length,
    const(git_oid)* input_array
);

int git_merge_file(
    git_merge_file_result* result_out,
    const(git_merge_file_input)* ancestor,
    const(git_merge_file_input)* ours,
    const(git_merge_file_input)* theirs,
    const(git_merge_file_options)* opts
);

int git_merge_file_from_index(
    git_merge_file_result* result_out,
    git_repository* repo,
    const(git_index_entry)* ancestor,
    const(git_index_entry)* ours,
    const(git_index_entry)* theirs,
    const(git_merge_file_options)* opts
);

void git_merge_file_result_free(git_merge_file_result* result);

int git_merge_trees(
    git_index** index_out,
    git_repository* repo,
    const(git_tree)* ancestor_tree,
    const(git_tree)* our_tree,
    const(git_tree)* their_tree,
    const(git_merge_options)* opts
);

int git_merge_commits(
    git_index** index_out,
    git_repository* repo,
    const(git_commit)* our_commit,
    const(git_commit)* their_commit,
    const(git_merge_options)* opts
);

int git_merge(
    git_repository* repo,
    const(git_annotated_commit*)* their_heads,
    size_t their_heads_len,
    const(git_merge_options)* merge_opts,
    const(git_checkout_options)* checkout_opts
);