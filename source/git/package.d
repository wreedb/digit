module git;

import core.stdc.stdlib : exit;
import std.stdio, std.string;

public import
    git.common,
    git.types,
    git.buffer,
    git.oid,
    git.object,
    git.commit,
    git.strarray,
    git.repository,
    git.cert,
    git.credential,
    git.credentialhelpers,
    git.proxy,
    git.remote,
    git.net,
    git.indexer,
    git.revparse,
    git.index,
    git.tree,
    git.describe,
    git.diff,
    git.email,
    git.errors,
    git.checkout,
    git.annotatedcommit,
    git.apply,
    git.attr,
    git.signature,
    git.blame,
    git.blob,
    git.branch,
    git.cherrypick,
    git.merge,
    git.oidarray,
    git.config,
    git.libversion,
    git.refs,
    git.refdb,
    git.refspec,
    git.reflog,
    git.clone,
    git.filter,
    git.graph,
    git.ignore,
    git.mailmap,
    git.message,
    git.notes,
    git.odb,
    git.odbbackend,
    git.pack,
    git.patch,
    git.pathspec,
    git.rebase,
    git.reset,
    git.revert,
    git.revwalk,
    git.stash,
    git.status,
    git.submodule,
    git.tag,
    git.trace,
    git.transaction,
    git.transport,
    git.sys;

extern (C):

int git_libgit2_init();
int git_libgit2_shutdown();

void GITCHECK(int err)
{
    if (err != 0)
    {
        const(git_error)* e = git_error_last();
        stderr.writeln(e.message.fromStringz);
        exit(git_libgit2_shutdown());
    }
}

void libgit2_init()
{
    git_libgit2_init();
}

void libgit2_shutdown()
{
    git_libgit2_shutdown();
}

git_checkout_options makeCheckoutOptions()
{
    git_checkout_options opts;
    GITCHECK(git_checkout_options_init(&opts, GIT_CHECKOUT_OPTIONS_VERSION));
    return opts;
}

git_fetch_options makeFetchOptions()
{
    git_fetch_options opts;
    GITCHECK(git_fetch_options_init(&opts, GIT_FETCH_OPTIONS_VERSION));
    return opts;
}
