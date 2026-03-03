#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <unistd.h>
#include <string.h>

int main() {
    DIR *d = opendir("film");
    struct dirent *e;
    char *f = NULL;
    unsigned n = 0;
    srand(getpid());
    while(e = readdir(d)) if (e->d_name[0] != '.' && rand() % ++n == 0) f = strdup(e->d_name);
    closedir(d);
    if(f) printf("Film for Trabowo & Peddy: '%s'\n", f);
    return 0;
}
