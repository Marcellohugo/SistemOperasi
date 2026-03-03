#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main(){
    const char *zip_file = "film.zip";
    const char *tujuan_dir = "film";
    const char *drive_url = "https://drive.google.com/uc?export=download&id=1nP5kjCi9ReDk5ILgnM7UCnrQwFH67Z9B";
    pid_t pid = fork();
    if(pid == 0){
        char *argv[] = {"wget", "-O", (char *)zip_file, (char *)drive_url, NULL};
        execvp(argv[0], argv);
    } 
    else wait(NULL);
    pid = fork();
    if(pid == 0){
        char *argv[] = {"unzip", "-j", (char *)zip_file, "-d", (char *)tujuan_dir, NULL};
        execvp(argv[0], argv);
    } 
    else wait(NULL);
    return 0;
}
