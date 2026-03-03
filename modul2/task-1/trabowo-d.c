#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(){
    pid_t pid = fork();
    if(pid == 0){
        char *argv[] = {"sh", "-c", "cd /home/farqil/Documents/sisop-modul-2-Farqil/task-1 && zip -r hasil.zip FilmHorror FilmAnimasi FilmDrama", NULL};
        execvp(argv[0], argv);
        
    } 
    else wait(NULL);
    pid_t hapuspid = fork();
    if(hapuspid == 0){
        char *rm_argv[] = {"rm", "-rf", "/home/farqil/Documents/sisop-modul-2-Farqil/task-1/FilmHorror", "/home/farqil/Documents/sisop-modul-2-Farqil/task-1/FilmAnimasi", "/home/farqil/Documents/sisop-modul-2-Farqil/task-1/FilmDrama",NULL};
        execvp(rm_argv[0], rm_argv);
    }
    else wait(NULL);
    return 0;
}
