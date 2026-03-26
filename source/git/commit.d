module git.commit;

import
    git.types,
    git.oid,
    git.buffer;

import std.bitmanip : bitfields;
import core.stdc.config : c_ulong;

alias size_t = c_ulong;

extern (C):

int git_commit_lookup(
    git_commit** c,
    git_repository* repo,
    const(git_oid)* id
);

int git_commit_lookup_prefix(
    git_commit** c,
    git_repository* repo,
    const(git_oid)* id,
    size_t len
);

void git_commit_free(git_commit* c);

const(git_oid)* git_commit_id(const(git_commit)* c);

git_repository* git_commit_owner(const(git_commit)* c);

const(char)* git_commit_message_encoding(const(git_commit)* c);

const(char)* git_commit_message(const(git_commit)* c);

const(char)* git_commit_message_raw(const(git_commit)* c);

const(char)* git_commit_summary(git_commit* c);

const(char)* git_commit_body(git_commit* c);

git_time_t git_commit_time(const(git_commit)* c);

int git_commit_time_offset(const(git_commit)* c);


const(git_signature)* git_commit_committer(const(git_commit)* c);

const(git_signature)* git_commit_author(const(git_commit)* c);

int git_commit_committer_with_mailmap(
    git_signature** sig,
    const(git_commit)* c,
    const(git_mailmap)* mailmap);

int git_commit_author_with_mailmap (
    git_signature** sig,
    const(git_commit)* c,
    const(git_mailmap)* mailmap);

const(char)* git_commit_raw_header(const(git_commit)* c);

int git_commit_tree(git_tree** tree_out, const(git_commit)* c);

const(git_oid)* git_commit_tree_id(const(git_commit)* c);

uint git_commit_parentcount(const(git_commit)* c);

int git_commit_parent(git_commit** commit_out, const(git_commit)* c, uint n);

const(git_oid)* git_commit_parent_id(const(git_commit)* c, uint n);

int git_commit_nth_gen_ancestor(
    git_commit** ancestor,
    const(git_commit)* c,
    uint n);

int git_commit_header_field(git_buf* buf, const(git_commit)* c, const(char)* field);

int git_commit_extract_signature(git_buf* sig, git_buf* data, git_repository* repo, git_oid* commit_id, const(char)* field);

int git_commit_create(
    git_oid* id,
    git_repository* repo,
    const(char)* update_ref,
    const(git_signature)* author,
    const(git_signature)* committer,
    const(char)* message_encoding,
    const(char)* message,
    const(git_tree)* tree,
    size_t parent_count,
    const(git_commit)** parents
);

int git_commit_create_v(
    git_oid* id,
    git_repository* repo,
    const(char)* update_ref,
    const(git_signature)* author,
    const(git_signature)* committer,
    const(char)* message_encoding,
    const(char)* message,
    const(git_tree)* tree,
    size_t parent_count,
    ...
);

struct git_commit_create_options
{
    uint version_;

    mixin(bitfields!(
        uint, "allow_empty_commit", 1,
        uint, "", 31));

    const(git_signature)* author;
    const(git_signature)* committer;

    const(char)* message_encoding;
}

enum GIT_COMMIT_CREATE_OPTIONS_VERSION = 1;

int git_commit_create_from_stage(
    git_oid* id,
    git_repository* repo,
    const(char)* message,
    const(git_commit_create_options)* opts);

int git_commit_amend(
    git_oid* id,
    const(git_commit)* commit_to_amend,
    const(char)* update_ref,
    const(git_signature)* author,
    const(git_signature)* committer,
    const(char)* message_encoding,
    const(char)* message,
    const(git_tree)* tree);

int git_commit_create_buffer(
    git_buf* buf,
    git_repository* repo,
    const(git_signature)* author,
    const(git_signature)* committer,
    const(char)* message_encoding,
    const(char)* message,
    const(git_tree)* tree,
    size_t parent_count,
    const(git_commit)** parents);

int git_commit_create_with_signature(
    git_oid* id,
    git_repository* repo,
    const(char)* commit_content,
    const(char)* signature,
    const(char)* signature_field);

int git_commit_dup(git_commit** commit_out, git_commit* source);

alias git_commit_create_cb = int function(
    git_oid* id_out,
    const(git_signature)* author,
    const(git_signature)* committer,
    const(char)* message_encoding,
    const(char)* message,
    const(git_tree)* tree,
    size_t parent_count,
    const(git_commit)*[] parents,
    void* payload
);

struct git_commitarray
{
    const(git_commit*)* commits;
    size_t count;
}

void git_commitarray_dispose(git_commitarray* ca);