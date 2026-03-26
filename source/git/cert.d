module git.cert;

import core.stdc.config;

alias size_t = c_ulong;

extern (C):

enum git_cert_t
{
    GIT_CERT_NONE            = 0,
    GIT_CERT_X509            = 1,
    GIT_CERT_HOSTKEY_LIBSSH2 = 2,
    GIT_CERT_STRARRAY        = 3
}

alias GIT_CERT_NONE = git_cert_t.GIT_CERT_NONE;
alias GIT_CERT_X509 = git_cert_t.GIT_CERT_X509;
alias GIT_CERT_HOSTKEY_LIBSSH2 = git_cert_t.GIT_CERT_HOSTKEY_LIBSSH2;
alias GIT_CERT_STRARRAY = git_cert_t.GIT_CERT_STRARRAY;

struct git_cert
{
    git_cert_t cert_type;
}

alias git_transport_certificate_check_cb = int function(git_cert* cert, int valid, const(char)* host, void* payload);

enum git_cert_ssh_t
{
    GIT_CERT_SSH_MD5    = 1 << 0,
    GIT_CERT_SSH_SHA1   = 1 << 1,
    GIT_CERT_SSH_SHA256 = 1 << 2,
    GIT_CERT_SSH_RAW    = 1 << 3
}

alias GIT_CERT_SSH_MD5 = git_cert_ssh_t.GIT_CERT_SSH_MD5;
alias GIT_CERT_SSH_SHA1 = git_cert_ssh_t.GIT_CERT_SSH_SHA1;
alias GIT_CERT_SSH_SHA256 = git_cert_ssh_t.GIT_CERT_SSH_SHA256;
alias GIT_CERT_SSH_RAW = git_cert_ssh_t.GIT_CERT_SSH_RAW;

enum git_cert_ssh_raw_type_t
{
    GIT_CERT_SSH_RAW_TYPE_UNKNOWN       = 0,
    GIT_CERT_SSH_RAW_TYPE_RSA           = 1,
    GIT_CERT_SSH_RAW_TYPE_DSS           = 2,
    GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_256 = 3,
    GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_384 = 4,
    GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_521 = 5,
    GIT_CERT_SSH_RAW_TYPE_KEY_ED25519   = 6
}

alias GIT_CERT_SSH_RAW_TYPE_UNKNOWN = git_cert_ssh_raw_type_t.GIT_CERT_SSH_RAW_TYPE_UNKNOWN;
alias GIT_CERT_SSH_RAW_TYPE_RSA = git_cert_ssh_raw_type_t.GIT_CERT_SSH_RAW_TYPE_RSA;
alias GIT_CERT_SSH_RAW_TYPE_DSS = git_cert_ssh_raw_type_t.GIT_CERT_SSH_RAW_TYPE_DSS;
alias GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_256 = git_cert_ssh_raw_type_t.GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_256;
alias GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_384 = git_cert_ssh_raw_type_t.GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_384;
alias GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_521 = git_cert_ssh_raw_type_t.GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_521;
alias GIT_CERT_SSH_RAW_TYPE_KEY_ED25519 = git_cert_ssh_raw_type_t.GIT_CERT_SSH_RAW_TYPE_KEY_ED25519;

struct git_cert_hostkey
{
    git_cert parent;
    git_cert_ssh_t type;
    ubyte[16] hash_md5;
    ubyte[20] hash_sha1;
    ubyte[32] hash_sha256;
    git_cert_ssh_raw_type_t raw_type;
    const(char)* hostkey;
    size_t hostkey_len;
}

struct git_cert_x509
{
    git_cert parent;
    void* data;
    size_t len;
}