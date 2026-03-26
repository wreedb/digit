module git.message;

import core.stdc.config;
alias size_t = c_ulong;

import git;

extern (C):

int git_message_prettify(git_buf* buf_out, const(char)* msg, int strip_comments, char comment_char);

struct git_message_trailer
{
    const(char)* key;
    const(char)* value;
}

struct git_message_trailer_array
{
    git_message_trailer* trailers;
    size_t count;
    char* trailer_block;
}

int git_message_trailers(git_message_trailer_array* arr, const(char)* msg);
void git_message_trailer_array_free(git_message_trailer_array* arr);