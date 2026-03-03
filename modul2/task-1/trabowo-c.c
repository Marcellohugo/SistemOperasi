#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/wait.h>
#include <time.h>

const char *cekgenre(const char *f){
    if(strstr(f, "horror")) return "FilmHorror";
    if(strstr(f, "animasi")) return "FilmAnimasi";
    if(strstr(f, "drama")) return "FilmDrama";
    return NULL;
}

int cekid(const char *f){
    char id[10]; int i = 0;
    while(f[i] != '_' && f[i] != '\0') id[i++] = f[i];
    id[i] = '\0';
    return atoi(id);
}

void *pindah(void *arg){
    char **a = (char **)arg;
    int s = atoi(a[0]), e = atoi(a[1]), step = atoi(a[2]);
    char **files = (char **)a[3];
    char *film_dir = a[4], *nama = a[5], *log_dir = a[6];
    const char *parent_dir = "."; 

    for(int i = s; i != e; i += step){
        char *f = files[i];
        const char *g = cekgenre(f);
        if(g && ((strcmp(nama, "Trabowo") == 0 && cekid(f) <= 25) || (strcmp(nama, "Peddy") == 0 && cekid(f) >= 26))){
            char src[300], dst[300];
            snprintf(src, sizeof(src), "%s/%s", film_dir, f);
            snprintf(dst, sizeof(dst), "%s/%s/%s", parent_dir, g, f);
            rename(src, dst);
            FILE *file = fopen(log_dir, "a");
            if(file){
                char t[30]; time_t now = time(NULL);
                strftime(t, sizeof(t), "%d-%m-%Y %H:%M:%S", localtime(&now));
                fprintf(file, "[%s] %s: %s telah dipindahkan ke %s\n", t, nama, f, g);
                fclose(file);
            }
        }    
    }
    return NULL;
}

void folder(const char *nama){
    if(fork() == 0){
        char *args[] ={"mkdir", "-p", (char *)nama, NULL};
        execvp("mkdir", args);
        exit(1);
    }
    else wait(NULL);
}

int compare(const void *a, const void *b){
    return cekid(*(const char **)a) - cekid(*(const char **)b);
}

void deletefolder(const char *path){
    if(fork() == 0){
        char *args[] ={"rm", "-rf", (char *)path, NULL};
        execvp("rm", args);
        exit(1);
    }
    else wait(NULL);
}

int main(){
    const char *film_dir = "film";  
    const char *log_dir = "recap.txt";
    const char *stat_dir = "total.txt";
    const char *genre_arr[] ={"FilmHorror", "FilmAnimasi", "FilmDrama"};
    int count = 0, jml[3] ={0};
    char *files[500];

    DIR *dir = opendir(film_dir); struct dirent *entry;
    while(entry = readdir(dir)) if(entry->d_name[0] != '.') files[count++] = strdup(entry->d_name);
    closedir(dir);
    for(int i = 0; i < count; i++){
        const char *g = cekgenre(files[i]);
        if(g){
            if(strcmp(g, genre_arr[0]) == 0) jml[0]++;
            else if(strcmp(g, genre_arr[1]) == 0) jml[1]++;
            else if(strcmp(g, genre_arr[2]) == 0) jml[2]++;
       }
    }
    for(int i = 0; i < 3; i++) folder(genre_arr[i]);
    qsort(files, count, sizeof(char *), compare);
    char *a1[] ={"0", "25", "1", (char *)files, (char *)film_dir, "Trabowo", (char *)log_dir};
    char *a2[] ={"49", "24", "-1", (char *)files, (char *)film_dir, "Peddy", (char *)log_dir};
    pthread_t t1, t2;
    pthread_create(&t1, NULL, pindah, a1);
    pthread_create(&t2, NULL, pindah, a2);
    pthread_join(t1, NULL); pthread_join(t2, NULL);
    int max = 0;
    for(int i = 1; i < 3; i++) if(jml[i] > jml[max]) max = i;
    FILE *stat = fopen(stat_dir, "w");
    if(stat){
        fprintf(stat, "Jumlah film horror: %d\nJumlah film animasi: %d\nJumlah film drama: %d\nGenre dengan jumlah film terbanyak: %s\n", jml[0], jml[1], jml[2], genre_arr[max] + 4);
        fclose(stat);
    }
    for(int i = 0; i < count; i++) free(files[i]);
    deletefolder(film_dir);
    return 0;
}
