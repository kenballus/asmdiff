#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define MAX_SRC_SIZE 4096
static uint8_t input[MAX_SRC_SIZE];
static uint8_t output[MAX_SRC_SIZE * 2];

int main(void) {
    size_t const n = fread(input, sizeof(uint8_t), MAX_SRC_SIZE, stdin);

    uint8_t const *const output_end = nal_escape(output, input, input + n);

    fwrite(output, sizeof(uint8_t), output_end - output, stdout);
}
