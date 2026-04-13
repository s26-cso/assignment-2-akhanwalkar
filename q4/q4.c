#include <stdio.h>
#include <string.h>  
#include <dlfcn.h>   
#include <stdint.h>  
typedef int (*op_func)(int, int);
int main(void)
{
    char op[6];   // operation name, at most 5 chars + null terminator
    char libname[16]; // will hold "./lib<op>.so\0"
    int num1, num2;
    while (scanf("%5s %d %d", op, &num1, &num2) == 3) {
        //building the library name using strcpy and strcat
        strcpy(libname, "./lib"); // libname = "./lib"
        strcat(libname, op); // libname = "./lib<op>"
        strcat(libname, ".so"); // libname = "./lib<op>.so"
        void *handle = dlopen(libname, RTLD_NOW | RTLD_LOCAL); //this loads the sahred library
        if (handle == NULL) {
            fprintf(stderr, "could not open %s: %s\n", libname, dlerror());
            return 1;
        }
        dlerror(); //clearnign errors
        op_func fn = (op_func)(uintptr_t)dlsym(handle, op); //looking up func by name
        if (dlerror() != NULL) {
            fprintf(stderr, "could not find function %s\n", op);
            dlclose(handle);
            return 1;
        }
        // call the function and print result
        printf("%d\n", fn(num1, num2));
        // unload immediately so we never hold more than one 1.5GB lib at once
        dlclose(handle);
    }
    return 0;
}