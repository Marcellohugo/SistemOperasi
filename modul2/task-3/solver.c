#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <sys/wait.h>
#include <dirent.h>
#include <pthread.h>

void caridata(char *tujuan, size_t size, const char *url, const char *jq_filter){
    char cmd[512], buf[256];
    snprintf(cmd, sizeof(cmd), "curl -s '%s' | jq -r '%s'", url, jq_filter);
    FILE *file = popen(cmd, "r");
    if(file){
        if(fgets(buf, sizeof(buf), file)){
            buf[strcspn(buf, "\n")] = 0;
            strncpy(tujuan, buf, size);
        }
        pclose(file);
    }
}

void api(int id){
    char url[128], judulmanhwa[256] = "", status[64] = "", release[64] = "", genres[256] = "", themes[256] = "", authors[256] = "";
    snprintf(url, sizeof(url), "https://api.jikan.moe/v4/manga/%d", id);
    caridata(judulmanhwa, sizeof(judulmanhwa), url, ".data.title_english // .data.judulmanhwa");
    caridata(status, sizeof(status), url, ".data.status");
    caridata(release, sizeof(release), url, ".data.published.from | if. == null then \"Unknown\" else .[:10] end");
    caridata(genres, sizeof(genres), url, "[.data.genres[].name] | join(\", \")");
    caridata(themes, sizeof(themes), url, "[.data.themes[].name] | join(\", \")");
    caridata(authors, sizeof(authors), url, "[.data.authors[].name] | join(\", \")");
    char filename[300];
    snprintf(filename, sizeof(filename), "Manhwa/%s.txt", judulmanhwa);
   for(char *p = filename; *p; p++) if(!isalnum(*p) && *p != '_' && *p != '/' && *p != '.') *p = '_';
    FILE *file = fopen(filename, "w");
    if(!file) return;
    fprintf(file, "Title: %s\nStatus: %s\nRelease: %s\nGenre: %s\nTheme: %s\nAuthor: %s", judulmanhwa, status, release, genres, themes, authors);
    fclose(file);
}

void zipkapital(){
    DIR *dir = opendir("Manhwa");
    if(!dir) return;
    pid_t pid = fork();
    if(pid == 0){
        char *argv[] ={"mkdir", "-p", "Archive", NULL};
        execvp(argv[0], argv);
        exit(1);
    } 
    else waitpid(pid, NULL, 0);
    struct dirent *entry;
    while((entry = readdir(dir)) != NULL){
        if(strstr(entry->d_name, ".txt")){
            char namazip[256] = "Archive/";
           for(int i = 0; entry->d_name[i] != '\0'; i++) if(entry->d_name[i] >= 'A' && entry->d_name[i] <= 'Z') strncat(namazip, &entry->d_name[i], 1);
            strcat(namazip, ".zip");
            char srcfile[256] = "Manhwa/";
            strcat(srcfile, entry->d_name);
            pid = fork();
            if(pid == 0){
                char *argv[] ={"zip", "-j", namazip, srcfile, NULL};
                execvp(argv[0], argv);
                exit(1);
            } 
            else waitpid(pid, NULL, 0);
        }
    }
    closedir(dir);
}

void *download_image(void *arg){
    char **args = (char **)arg;
    pid_t pid = fork();
    if(pid == 0){
        char *argv[] ={"wget", "-q", "-O", args[0], args[1], NULL};
        execvp(argv[0], argv);
        exit(1);
    } else waitpid(pid, NULL, 0);
    pthread_exit(NULL);
}

void gambarheroine(const char *heroine, const char *manhwa, const char *url){
    DIR *dir = opendir("Manhwa");
    if(!dir) return;
    struct dirent *entry;
    while((entry = readdir(dir)) != NULL){
        if(strstr(entry->d_name, ".txt")){
            char path[512], line[256], judulmanhwa[256];
            snprintf(path, sizeof(path), "Manhwa/%s", entry->d_name);
            FILE *file = fopen(path, "r");
            if(!file) continue;
            int yes = 0, jumlahfoto = 0;
            while(fgets(line, sizeof(line), file)){
                if(strstr(line, "Title:")){
                    sscanf(line, "Title: %[^\n]", judulmanhwa);
                    if(strcmp(judulmanhwa, manhwa) == 0) yes = 1; else break;
                }
                if(yes && strstr(line, "Release:")){
                    sscanf(line, "Release: %*d-%d-%*d", &jumlahfoto);
                    break;
                }
            }
            fclose(file);
            if(yes && jumlahfoto > 0){
                pid_t pid = fork();
                if(pid == 0){
                    char folder[128];
                    snprintf(folder, sizeof(folder), "Heroines/%s", heroine);
                    char *argv[] ={"mkdir", "-p", folder, NULL};
                    execvp(argv[0], argv);
                    exit(1);
                } 
                else waitpid(pid, NULL, 0);
                pthread_t threads[jumlahfoto];
                for(int i = 1; i <= jumlahfoto; i++){
                    char **args = malloc(2 * sizeof(char *));
                    char file[256], url[512];
                    snprintf(file, sizeof(file), "Heroines/%s/%s_%d.jpg", heroine, heroine, i);
                    snprintf(url, sizeof(url), url, heroine, i);
                    args[0] = strdup(file);
                    args[1] = strdup(url);
                    pthread_create(&threads[i - 1], NULL, download_image, args);
                }
                for(int i = 0; i < jumlahfoto; i++) pthread_join(threads[i], NULL);
                break;
            }
        }
    }
    closedir(dir);
}

void zipheroine(const char *manhwa, const char *heroine){
    char zip[512];
    char direktori[] = "Archive/Images";
    char hurufkapital[256];
    int j = 0;
    for(int i = 0; manhwa[i] != '\0'; i++) if(manhwa[i] >= 'A' && manhwa[i] <= 'Z') hurufkapital[j++] = manhwa[i];
    hurufkapital[j] = '\0';

    pid_t pid = fork();
    if(pid == 0){
        char *argv[] ={"mkdir", "-p", direktori, NULL};
        execvp(argv[0], argv);
        exit(1);
    } 
    else waitpid(pid, NULL, 0);
    snprintf(zip, sizeof(zip), "../../%s/%s_%s.zip", direktori, hurufkapital, heroine);
    pid = fork();
    if(pid == 0){
        char folder[128];
        snprintf(folder, sizeof(folder), "/home/farqil/Documents/sisop-modul-2-Farqil/task-3/Heroines/%s", heroine);
        char command[1024];
        snprintf(command, sizeof(command), "cd %s && zip -r %s *", folder, zip); 
        char *argv[] ={"sh", "-c", command, NULL};
        execvp(argv[0], argv);
        exit(1);
    } 
    else waitpid(pid, NULL, 0);
    char path[512];
    snprintf(path, sizeof(path), "/home/farqil/Documents/sisop-modul-2-Farqil/task-3/Heroines/%s", heroine);
    pid = fork();
    if(pid == 0){
        char *argv[] ={"rm", "-rf", path, NULL};
        execvp(argv[0], argv);
        exit(1);
    }
}

int main(){
    pid_t pid = fork();
    if(pid == 0){
        char *argv[] ={"mkdir", "-p", "Manhwa", NULL};
        execvp(argv[0], argv);
        exit(1);
    }
    else waitpid(pid, NULL, 0);
    int id[] ={168827, 147205, 169731, 175521};
    for(int i = 0; i < 4; i++) api(id[i]);
    zipkapital();
    const char *heroine[] ={"Adelia", "Lia", "Ophelia", "Tia"};
    const char *manhwa[] ={"No, I Only Charmed the Princess!", "Mistaken as the Monster Duke's Wife", "Darling, Why Can't We Divorce?", "The Villainess Lives Again"};
    const char *url[] ={"https://i.pinimg.com/736x/09/81/6c/09816c1e9e3306c67ecbc2db318a6b93.jpg", "https://i.pinimg.com/736x/cc/88/fc/cc88fc7520e11783dccbf081dcf5293d.jpg", "https://i.pinimg.com/736x/17/3a/ae/173aaec355eed29a86c423009eba7710.jpg", "https://i.pinimg.com/736x/ab/e4/f0/abe4f0004953bccb57b2e8ed17bd6263.jpg"};
    for(int i = 0; i < 4; i++) gambarheroine(heroine[i], manhwa[i], url[i]);
    for(int i = 0; i < 4; i++) zipheroine(manhwa[i], heroine[i]);
    return 0;
}
