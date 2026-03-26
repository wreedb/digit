module git.libversion;
import core.stdc.stddef;

extern (C):

enum LIBGIT2_VERSION = "1.9.2";
enum LIBGIT2_VERSION_MAJOR = 1;
enum LIBGIT2_VERSION_MINOR = 9;
enum LIBGIT2_VERSION_REVISION = 2;
enum LIBGIT2_VERSION_PATCH = 0;
enum LIBGIT2_VERSION_PRERELEASE = null;
enum LIBGIT2_SOVERSION = "1.9";
enum LIBGIT2_VERSION_NUMBER = (LIBGIT2_VERSION_MAJOR * 1000000) + (LIBGIT2_VERSION_MINOR * 10000) + (LIBGIT2_VERSION_REVISION * 100);

extern (D) auto LIBGIT2_VERSION_CHECK(T0, T1, T2)(auto ref T0 major, auto ref T1 minor, auto ref T2 revision)
{
    return LIBGIT2_VERSION_NUMBER >= (major * 1000000) + (minor * 10000) + (revision * 100);
}