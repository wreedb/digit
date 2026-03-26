module git.oid;

import core.stdc.config : c_ulong;

alias size_t = c_ulong;

extern (C):

enum git_oid_t
{
    GIT_OID_SHA1 = 1
}

alias GIT_OID_SHA1 = git_oid_t.GIT_OID_SHA1;

enum GIT_OID_DEFAULT      = git_oid_t.GIT_OID_SHA1;
enum GIT_OID_SHA1_SIZE    = 20;
enum GIT_OID_SHA1_HEXSIZE = GIT_OID_SHA1_SIZE * 2;
enum GIT_OID_SHA1_HEXZERO = "0000000000000000000000000000000000000000";
enum GIT_OID_MAX_SIZE     = GIT_OID_SHA1_SIZE;
enum GIT_OID_MAX_HEXSIZE  = GIT_OID_SHA1_HEXSIZE;
enum GIT_OID_MINPREFIXLEN = 4;

struct git_oid
{
    ubyte[GIT_OID_MAX_SIZE] id;
}

int git_oid_fromstr (git_oid* oid, const(char)* str);
int git_oid_fromstrp (git_oid* oid, const(char)* str);
int git_oid_fromstrn (git_oid* oid, const(char)* str, size_t length);
int git_oid_fromraw (git_oid* oid, const(ubyte)* raw);
int git_oid_fmt (char* s, const(git_oid)* id);
int git_oid_nfmt (char* s, size_t n, const(git_oid)* id);
int git_oid_pathfmt (char* s, const(git_oid)* id);
char* git_oid_tostr_s (const(git_oid)* oid);
char* git_oid_tostr (char* s, size_t n, const(git_oid)* id);
int git_oid_cpy (git_oid* oid, const(git_oid)* src);
int git_oid_cmp (const(git_oid)* a, const(git_oid)* b);
int git_oid_equal (const(git_oid)* a, const(git_oid)* b);
int git_oid_ncmp (const(git_oid)* a, const(git_oid)* b, size_t len);
int git_oid_streq (const(git_oid)* id, const(char)* str);
int git_oid_strcmp (const(git_oid)* id, const(char)* str);
int git_oid_is_zero (const(git_oid)* id);

struct git_oid_shorten;
git_oid_shorten* git_oid_shorten_new (size_t min_length);
int git_oid_shorten_add (git_oid_shorten* os, const(char)* text_id);
void git_oid_shorten_free (git_oid_shorten* os);