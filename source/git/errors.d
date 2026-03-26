module git.errors;

import git;

import core.stdc.config;
alias size_t = c_ulong;

extern (C):

enum git_error_code
{
    ok = 0,
    error = -1,
    enotfound = -3,
    eexists = -4,
    eambiguous = -5,
    ebufs = -6,
    euser = -7,
    ebarerepo = -8,
    eunbornbranch = -9,
    eunmerged = -10,
    enonfastforward = -11,
    einvalidspec = -12,
    econflict = -13,
    elocked = -14,
    emodified = -15,
    eauth = -16,
    ecertificate = -17,
    eapplied = -18,
    epeel = -19,
    eeof = -20,
    einvalid = -21,
    euncommitted = -22,
    edirectory = -23,
    emergeconflict = -24,
    passthrough = -30,
    iterover = -31,
    retry = -32,
    emismatch = -33,
    eindexdirty = -34,
    eapplyfail = -35,
    eowner = -36,
    timeout = -37,
    eunchanged = -38,
    enotsupported = -39,
    ereadonly = -40
}

enum git_error_t
{
    none = 0,
    nomemory = 1,
    os = 2,
    invalid = 3,
    reference = 4,
    zlib = 5,
    repository = 6,
    config = 7,
    regex = 8,
    odb = 9,
    index = 10,
    object = 11,
    net = 12,
    tag = 13,
    tree = 14,
    indexer = 15,
    ssl = 16,
    submodule = 17,
    thread = 18,
    stash = 19,
    checkout = 20,
    fetchhead = 21,
    merge = 22,
    ssh = 23,
    filter = 24,
    revert = 25,
    callback = 26,
    cherrypick = 27,
    describe = 28,
    rebase = 29,
    filesystem = 30,
    patch = 31,
    worktree = 32,
    sha = 33,
    http = 34,
    internal = 35,
    grafts = 36
}

struct git_error
{
    char* message;
    int klass;
}

const(git_error)* git_error_last();