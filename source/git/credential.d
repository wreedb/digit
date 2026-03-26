module git.credential;

import git.types, git.sys.credential;

import core.stdc.config;

alias size_t = c_ulong;

extern (C):

enum git_credential_t
{
    userpass_plaintext = (1u << 0),
    ssh_key            = (1u << 1),
    ssh_custom         = (1u << 2),
    normal             = (1u << 3),
    ssh_interactive    = (1u << 4),
    username           = (1u << 5),
    ssh_memory         = (1u << 6)
}

// struct git_credential;
// struct git_credential_userpass_plaintext;
// struct git_credential_username;

alias git_credential_default = git_credential;
// struct git_credential_ssh_key;
// struct git_credential_ssh_interactive;
// struct git_credential_ssh_custom;

alias git_credential_acquire_cb = int function(
    git_credential** credential_out,
    const(char)* url,
    const(char)* username_from_url,
    uint allowed_types,
    void* payload
);

void git_credential_free(git_credential* cred);
int git_credential_has_username(git_credential* cred);

const(char)* git_credential_get_username(git_credential* cred);

int git_credential_userpass_plaintext_new(
    git_credential** cred_out,
    const(char)* username,
    const(char)* password
);

int git_credential_default_new(git_credential** cred_out);
int git_credential_username_new(git_credential** cred_out, const(char)* username);

int git_credential_ssh_key_new(
    git_credential** cred_out,
    const(char)* username,
    const(char)* publickey,
    const(char)* privatekey,
    const(char)* passphrase
);

int git_credential_ssh_key_memory_new(
    git_credential** cred_out,
    const(char)* username,
    const(char)* publickey,
    const(char)* privatekey,
    const(char)* passphrase
);

struct _LIBSSH2_SESSION;
alias LIBSSH2_SESSION = _LIBSSH2_SESSION;
struct _LIBSSH2_USERAUTH_KBDINT_PROMPT;
alias LIBSSH2_USERAUTH_KBDINT_PROMPT = _LIBSSH2_USERAUTH_KBDINT_PROMPT;
struct _LIBSSH2_USERAUTH_KBDINT_RESPONSE;
alias LIBSSH2_USERAUTH_KBDINT_RESPONSE = _LIBSSH2_USERAUTH_KBDINT_RESPONSE;

alias git_credential_ssh_interactive_cb = void function(
    const(char)* name,
    int name_len,
    const(char)* instruction,
    int instruction_len,
    int num_prompts,
    const(LIBSSH2_USERAUTH_KBDINT_PROMPT)* prompts,
    LIBSSH2_USERAUTH_KBDINT_RESPONSE* responses,
    void** abstract_
);

int git_credential_ssh_interactive_new(
    git_credential** out_,
    const(char)* username,
    git_credential_ssh_interactive_cb prompt_callback,
    void* payload
);

int git_credential_ssh_key_from_agent(
    git_credential** out_,
    const(char)* username
);

alias git_credential_sign_cb = int function(
    LIBSSH2_SESSION* session,
    ubyte** sig,
    size_t* sig_len,
    const(ubyte)* data,
    size_t data_len,
    void** abstract_
);

int git_credential_ssh_custom_new(
    git_credential** out_,
    const(char)* username,
    const(char)* publickey,
    size_t publickey_len,
    git_credential_sign_cb sign_callback,
    void* payload
);