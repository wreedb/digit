module git.sys.credential;

import core.stdc.config;
alias size_t = c_ulong;

import git, git.sys;

extern (C):

struct git_credential
{
    git_credential_t credtype;
    void function(git_credential* cred) free;
}

struct git_credential_userpass_plaintext
{
    git_credential parent;
    char* username;
    char* password;
}

struct git_credential_username
{
    git_credential parent;
    char[1] username;
}

struct git_credential_ssh_key
{
    git_credential parent;
    char* username;
    char* publickey;
    char* privatekey;
    char* passphrase;
}

struct git_credential_ssh_interactive
{
    git_credential parent;
    char* username;
    git_credential_ssh_interactive_cb prompt_callback;
    void* payload;
}

struct git_credential_ssh_custom
{
    git_credential parent;
    char* username;
    char* publickey;
    size_t publickey_len;
    git_credential_sign_cb sign_callback;
    void* payload;
}