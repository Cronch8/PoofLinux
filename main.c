#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <time.h>

int main(int argc, char *argv[]) {
    char exe_path[4096];
    ssize_t len = readlink("/proc/self/exe", exe_path, sizeof(exe_path) - 1);
    if (len < 0) {
        perror("readlink /proc/self/exe");
        return 1;
    }
    exe_path[len] = '\0';

    /* Use basename — handles /bin -> /usr/bin symlink on modern Linux distros */
    const char *name = strrchr(exe_path, '/');
    if (!name) {
        fprintf(stderr, "error: unexpected executable path '%s'\n", exe_path);
        return 1;
    }
    name++; /* skip past the '/' */

    /* Build target path: /bin-copy/<name> */
    char new_path[4096];
    snprintf(new_path, sizeof(new_path), "/bin-copy/%s", name);

    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    srand(ts.tv_nsec);
    int random_num = rand() % 100;
    if (random_num >= 50)
    {
        execv(new_path, argv);
        /* execv only returns on error */
        fprintf(stderr, "execv('%s') failed: %s\n", new_path, strerror(errno));
        return 1;
    }
    return 0;
}
