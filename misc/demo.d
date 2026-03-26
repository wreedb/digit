import git;
import core.stdc.config : c_ulong;
alias size_t = c_ulong;
import
    std.conv,
    std.stdio,
    std.format,
    std.string,
    std.algorithm,
    std.range;

extern (C) int fetch_cb(const(git_indexer_progress)* stats, void *userdata)
{
    if (stats.received_objects == 0)
    {
        write("\rpreparing...");
        stdout.flush();
        return 0;
    }
    double mb = (stats.received_bytes / 1000000.00);
    string displaymb = format("%.1f", mb);
    size_t filled = (stats.received_objects * 40) / stats.total_objects;
    size_t remaining = 40 - filled;

    string finished = "#".replicate(filled);
    string unfinished = "#".replicate(remaining);
    if (remaining == 0)
    {
        writef("\r[\033[32m%s\033[m] %s MB", finished, displaymb);
        stdout.flush();
        return 0;
    } else {
        writef("\r[\033[32m%s\033[m%s] %s MB", finished, unfinished, displaymb);
        stdout.flush();
        return 0;
    }
}

extern (C) void co_cb(const(char)* path, size_t completed, size_t total, void* userdata)
{
    if (completed == 0)
    {
        write("\rpreparing...");
        stdout.flush();
        return;
    }
    size_t percent = (completed * 100) / total;
    size_t filled = (completed * 40) / total;
    size_t remaining = (40 - filled);

    string finished = "#".replicate(filled);
    string unfinished = "#".replicate(remaining);

    writef("\r[\033[32m%s\033[m%s] %d%%", finished, unfinished, percent);
    stdout.flush();
    return;
};

int main(string[] args)
{
    if (args.length < 4)
        return 1;

    string url = args[1];
    string tag = args[2];
    string path = args[3];

    libgit2_init();

    git_remote* remote;
    git_repository* repo;

    git_repository_init(&repo, path.toStringz, 0);
    git_remote_create(&remote, repo, "origin", url.toStringz);

    char* refspec = cast(char*)format("+refs/tags/%s:refs/tags/%s", tag, tag).toStringz;
    string revspec = format("refs/tags/%s", tag);
    git_strarray sarr;
    sarr.strings = &refspec;
    sarr.count = 1;

    auto checkopts = makeCheckoutOptions();
    auto fetchopts = makeFetchOptions();

    checkopts.checkout_strategy = git_checkout_strategy_t.safe;

    checkopts.progress_cb = &co_cb;
    fetchopts.callbacks.transfer_progress = &fetch_cb;
    fetchopts.depth = 1;
    fetchopts.follow_redirects = git_remote_redirect_t.initial;

    stdout.write("\r\033[?25l");
    git_remote_fetch(remote, &sarr, &fetchopts, null);
    stdout.write("\r\033[?25h\n");
    stdout.flush();

    git_object* rev;


    stdout.write("\r\033[?25l");
    git_revparse_single(&rev, repo, revspec.toStringz);
    git_checkout_tree(repo, rev, &checkopts);
    git_repository_set_head_detached(repo, git_object_id(rev));
    stdout.write("\r\033[?25h\n");
    stdout.flush();

    git_remote_free(remote);
    git_repository_free(repo);

    libgit2_shutdown();
    return 0;
}
