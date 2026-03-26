module git.blame;

import core.stdc.config;
alias size_t = c_ulong;

import git.oid, git.types, git.signature;

extern (C):

enum git_blame_flag_t : uint
{
    normal = 0,
    track_copies_same_file = (1<<0),
    track_copies_same_commit_moves = (1<<1),
    track_copies_same_commit_copies = (1<<2),
    track_copies_any_commit_copies = (1<<3),
    first_parent = (1<<4),
    use_mailmap = (1<<5),
    ignore_whitespace = (1<<6)
}

struct git_blame_options
{
    uint version_;
    uint flags;
    uint min_match_characters;
    git_oid newest_commit;
    git_oid oldest_commit;
    size_t min_line;
    size_t max_line;
}

enum GIT_BLAME_OPTIONS_VERSION = 1;

int git_blame_options_init(git_blame_options* options, uint version_);

struct git_blame_hunk
{
    size_t lines_in_hunk;
    git_oid final_commit_id;
    size_t final_start_line_number;
    git_signature* final_signature;
    git_signature* final_committer;
    git_oid orig_commit_id;
    const(char)* orig_path;
    size_t orig_start_line_number;
    git_signature* orig_signature;
    git_signature* orig_committer;
    const(char)* summary;
    char boundary;
}

struct git_blame_line
{
    const(char)* ptr;
    size_t len;
}

struct git_blame;

size_t git_blame_linecount(git_blame* blame);
size_t git_blame_hunkcount(git_blame* blame);
const(git_blame_hunk)* git_blame_hunk_byindex(git_blame* blame, size_t index);

const(git_blame_hunk)* git_blame_hunk_byline(git_blame* blame, size_t lineno);
const(git_blame_line)* git_blame_line_byindex(git_blame* blame, size_t index);

uint git_blame_get_hunk_count(git_blame* blame);

const(git_blame_hunk)* git_blame_get_hunk_byindex(git_blame* blame, uint index);
const(git_blame_hunk)* git_blame_get_hunk_byline(git_blame* blame, size_t lineno);

int git_blame_file(git_blame** blame_out, git_repository* repo, const(char)* path, git_blame_options* options);
int git_blame_file_from_buffer(git_blame** blame_out, git_repository* repo, const(char)* path, const(char)* contents, size_t contents_len, git_blame_options* options);
int git_blame_buffer(git_blame** blame_out, git_blame* base, const(char)* buffer, size_t buffer_length);

void git_blame_free(git_blame* blame);