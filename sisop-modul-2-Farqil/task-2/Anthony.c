// File: Anthony.c

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <pthread.h>

#define MAX_LINE      1024
#define MAX_COUNTRY   200

typedef struct {
    char country[128];
    int before_2000;
    int after_2000;
} CountryStats;

typedef struct {
    CountryStats stats[MAX_COUNTRY];
    int count;
    pthread_mutex_t lock;
} ReportData;

// Hilangkan newline/carriage return di ujung string
void trim_newline(char *s) {
    char *p = s + strlen(s) - 1;
    while (p >= s && (*p == '\n' || *p == '\r')) {
        *p-- = '\0';
    }
}

void *thread_process_csv(void *arg) {
    ReportData *rd = (ReportData *)arg;
    FILE *f = fopen("netflixData/netflixData.csv", "r");
    if (!f) {
        perror("Gagal membuka netflixData/netflixData.csv");
        pthread_exit(NULL);
    }

    char line[MAX_LINE];
    int lineno = 0;
    while (fgets(line, sizeof(line), f)) {
        lineno++;
        if (lineno == 1) continue;  // skip header

        trim_newline(line);
        // Tokenize: title,director,country,release year
        char *title    = strtok(line, ",");
        char *director = strtok(NULL, ",");
        char *country  = strtok(NULL, ",");
        char *year_s   = strtok(NULL, ",");

        if (!country || !year_s) continue;
        int year = atoi(year_s);
        if (year <= 0) continue;

        // update stats
        pthread_mutex_lock(&rd->lock);
        int found = 0;
        for (int i = 0; i < rd->count; i++) {
            if (strcmp(rd->stats[i].country, country) == 0) {
                if (year < 2000) rd->stats[i].before_2000++;
                else             rd->stats[i].after_2000++;
                found = 1;
                break;
            }
        }
        if (!found && rd->count < MAX_COUNTRY) {
            // tambah negara baru
            CountryStats *cs = &rd->stats[rd->count];
            strncpy(cs->country, country, sizeof(cs->country)-1);
            cs->country[sizeof(cs->country)-1] = '\0';
            cs->before_2000 = (year < 2000);
            cs->after_2000  = (year >= 2000);
            rd->count++;
        }
        pthread_mutex_unlock(&rd->lock);
    }

    fclose(f);
    pthread_exit(NULL);
}

int main(void) {
    ReportData rd;
    rd.count = 0;
    pthread_mutex_init(&rd.lock, NULL);

    // jalankan single thread untuk memproses CSV
    pthread_t tid;
    if (pthread_create(&tid, NULL, thread_process_csv, &rd)) {
        fprintf(stderr, "Error membuat thread\n");
        return 1;
    }
    pthread_join(tid, NULL);

    // buat nama file report_DDMMYYYY.txt
    time_t now = time(NULL);
    struct tm *t = localtime(&now);
    char fname[64];
    strftime(fname, sizeof(fname), "report_%d%m%Y.txt", t);

    FILE *out = fopen(fname, "w");
    if (!out) {
        perror("Gagal membuat file laporan");
        return 1;
    }

    for (int i = 0; i < rd.count; i++) {
        fprintf(out,
            "%d. Negara: %s\n"
            "   Film sebelum 2000: %d\n"
            "   Film setelah 2000: %d\n\n",
            i+1,
            rd.stats[i].country,
            rd.stats[i].before_2000,
            rd.stats[i].after_2000
        );
    }
    fclose(out);
    pthread_mutex_destroy(&rd.lock);

    printf("✅ Report generated: %s\n", fname);
    return 0;
}
