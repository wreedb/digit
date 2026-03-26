module git.sys.alloc;

import core.stdc.config;
alias size_t = c_ulong;

extern (C):

struct git_allocator
{
    void* function(size_t n, const(char)* file, int line) gmalloc;
    void* function(void* ptr, size_t size, const(char)* file, int line) grealloc;
    void function(void* ptr) gfree;
}

int git_stdalloc_init_allocator(git_allocator* allocator);
int git_win32_crtdbg_init_allocator(git_allocator* allocator);