module git.sys.errors;

extern (C):

void git_error_clear();
void git_error_set(int error_class, const(char)* fmt, ...);
int git_error_set_str(int error_class, const(char)* string);
void git_error_set_oom();