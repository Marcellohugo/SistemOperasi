#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ipc.h>
#include <sys/shm.h>

#define SHM_KEY 1234
#define MAX_MSG_LEN 256

typedef struct {
    char message[MAX_MSG_LEN];
    int count;
} SharedData;

int main() {
    char input[300];
    printf("Masukkan pesan dan jumlah (format: Pesan;Jumlah): ");
    fgets(input, sizeof(input), stdin);
    input[strcspn(input, "\n")] = '\0';  // hapus newline

    // Parsing input
    char *token = strtok(input, ";");
    if (token == NULL) {
        fprintf(stderr, "Format salah. Harus Pesan;Jumlah\n");
        return 1;
    }

    char pesan[MAX_MSG_LEN];
    strncpy(pesan, token, MAX_MSG_LEN);

    token = strtok(NULL, ";");
    if (token == NULL) {
        fprintf(stderr, "Jumlah tidak ditemukan.\n");
        return 1;
    }
    int jumlah = atoi(token);

    // Akses atau buat shared memory
    int shmid = shmget(SHM_KEY, sizeof(SharedData), IPC_CREAT | 0666);
    if (shmid < 0) {
        perror("shmget error");
        return 1;
    }

    SharedData *data = (SharedData *) shmat(shmid, NULL, 0);
    if (data == (void *) -1) {
        perror("shmat error");
        return 1;
    }

    // Tulis ke shared memory
    strncpy(data->message, pesan, MAX_MSG_LEN);
    data->count = jumlah;

    // Tulis ke log
    FILE *log = fopen("sistem.log", "a");
    if (log != NULL) {
        fprintf(log, "Message from client: %s\n", pesan);
        fprintf(log, "Message count: %d\n", jumlah);
        fclose(log);
    } else {
        perror("Gagal membuka sistem.log");
    }

    // Detach shared memory
    shmdt(data);

    printf("Pesan dikirim ke load balancer melalui shared memory.\n");
    return 0;
}
