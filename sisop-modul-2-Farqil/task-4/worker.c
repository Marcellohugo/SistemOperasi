#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <unistd.h>

#define MAX_MSG_LEN 256

struct msg_buffer {
    long msg_type;
    char msg_text[MAX_MSG_LEN];
};

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <worker_id> <jumlah_pesan>\n", argv[0]);
        return 1;
    }

    int worker_id = atoi(argv[1]);        // misalnya: 0, 1, 2...
    int jumlah_pesan = atoi(argv[2]);     // jumlah pesan yang akan diterima

    key_t key = ftok(".", 'A' + worker_id);
    int msgid = msgget(key, 0666);
    if (msgid < 0) {
        perror("msgget error");
        return 1;
    }

    FILE *log = fopen("sistem.log", "a");
    if (!log) {
        perror("Gagal membuka sistem.log");
        return 1;
    }

    int received_count = 0;
    struct msg_buffer msg;
    while (received_count < jumlah_pesan) {
        if (msgrcv(msgid, &msg, sizeof(msg.msg_text), 0, 0) < 0) {
            perror("msgrcv error");
            continue;
        }

        fprintf(log, "Worker%d: message received\n", worker_id + 1);
        received_count++;
    }

    // Tulis total pesan setelah selesai
    fprintf(log, "Worker %d: %d messages\n", worker_id + 1, received_count);
    fclose(log);

    printf("Worker %d selesai menerima %d pesan.\n", worker_id + 1, received_count);
    return 0;
}
