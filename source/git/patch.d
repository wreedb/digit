module git.patch;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

struct git_patch;

git_repository* git_patch_owner(const(git_patch)* patch);
int git_patch_from_diff(git_patch** patch_out, git_diff* diff, size_t idx);

int git_patch_from_blobs(
    git_patch** patch_out,
    const(git_blob)* old_blob,
    const(char)* old_as_path,
    const(git_blob)* new_blob,
    const(char)* new_as_path,
    const(git_diff_options)* opts);

int git_patch_from_blob_and_buffer(
    git_patch** patch_out,
    const(git_blob)* old_blob,
    const(char)* old_as_path,
    const(void)* buffer,
    size_t buffer_len,
    const(char)* buffer_as_path,
    const(git_diff_options)* opts);

int git_patch_from_buffers(
    git_patch** patch_out,
    const(void)* old_buffer,
    size_t old_len,
    const(char)* old_as_path,
    const(void)* new_buffer,
    size_t new_len,
    const(char)* new_as_path,
    const(git_diff_options)* opts);

void git_patch_free(git_patch* patch);
const(git_diff_delta)* git_patch_get_delta(const(git_patch)* patch);
size_t git_patch_num_hunks(const(git_patch)* patch);

int git_patch_line_stats(
    size_t* total_context,
    size_t* total_additions,
    size_t* total_deletions,
    const(git_patch)* patch
);

int git_patch_get_hunk(
    const(git_diff_hunk*)* dhunk_out,
    size_t* lines_in_hunk,
    git_patch* patch,
    size_t hunk_idx
);

int git_patch_num_lines_in_hunk(const(git_patch)* patch, size_t hunk_idx);

int git_patch_get_line_in_hunk(
    const(git_diff_line*)* dline_out,
    git_patch* patch,
    size_t hunk_idx,
    size_t line_of_hunk
);

size_t git_patch_size(
    git_patch* patch,
    int include_context,
    int include_hunk_headers,
    int include_file_headers
);

int git_patch_print(git_patch* patch, git_diff_line_cb print_cb, void* payload);
int git_patch_to_buf(git_buf* buf_out, git_patch* patch);