module git.credentialhelpers;

import git;

extern (C):

struct git_credential_userpass_payload
{
    const(char)* username;
    const(char)* password;
}

int git_credential_userpass(
    git_credential** cred_out,
    const(char)* url,
    const(char)* user_from_url,
    uint allowed_types,
    void* payload
);