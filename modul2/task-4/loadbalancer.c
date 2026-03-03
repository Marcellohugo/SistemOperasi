#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/msg.h>
#include <unistd.h>

#define SHM_KEY 1234
#define MAX_MSG_LEN 256
#define MAX_WORKERS 10

typedef struct {
    char message[MAX_MSG_LEN];
    int count;
} SharedData;

struct msg_buffer {
    long msg_type;
    char msg_text[MAX_MSG_LEN];
};

int main() {
    int num_workers;
    printf("Masukkan jumlah worker: ");
    scanf("%d", &num_workers);

    if (num_workers > MAX_WORKERS || num_workers <= 0) {
        printf("Jumlah worker tidak valid (maks %d)\n", MAX_WORKERS);
        return 1;
    }

    // Ambil shared memory
    int shmid = shmget(SHM_KEY, sizeof(SharedData), 0666);
    if (shmid < 0) {
        perror("shmget error");
        return 1;
    }

    SharedData *data = (SharedData *) shmat(shmid, NULL, 0);
    if (data == (void *) -1) {
        perror("shmat error");
        return 1;
    }

    // Setup message queue untuk tiap worker
    int msgids[MAX_WORKERS];
    for (int i = 0; i < num_workers; i++) {
        key_t key = ftok(".", 'A' + i);  // unik untuk setiap worker
        msgids[i] = msgget(key, IPC_CREAT | 0666);
        if (msgids[i] < 0) {
            perror("msgget error");
            return 1;
        }
    }

    FILE *log = fopen("sistem.log", "a");
    if (!log) {
        perror("Gagal membuka sistem.log");
        return 1;
    }

    for (int i = 0; i < data->count; i++) {
        // Tulis log
        fprintf(log, "Received at lb: %s (#message %d)\n", data->message, i + 1);

        // Kirim pesan ke worker round-robin
        int worker_id = i % num_workers;
        struct msg_buffer msg;
        msg.msg_type = 1;
        strncpy(msg.msg_text, data->message, MAX_MSG_LEN);

        if (msgsnd(msgids[worker_id], &msg, sizeof(msg.msg_text), 0) < 0) {
            perror("msgsnd error");
        }
    }

    fclose(log);
    shmdt(data); // detach shared memory

    printf("Pesan telah didistribusikan ke worker menggunakan round-robin.\n");
    return 0;
}
