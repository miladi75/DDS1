#include <iostream>
#include <cmath>

#define BUFFER_SIZE 256

// (x^e) % m
int32_t modular_exp(int32_t x, int32_t e, int32_t m)
{
    if (m == 1)
    {
        return 0;
    }

    int32_t c = 1;
    for (int32_t ep = 0; ep < e; ep++)
    {
        c = (c * x) % m;
    }

    return c;
}

void encrypt(int32_t e, int32_t n, int32_t msg_plain[BUFFER_SIZE], int32_t msg_encr[BUFFER_SIZE])
{
    for (size_t i = 0; i < BUFFER_SIZE; i++)
    {
        msg_encr[i] = modular_exp(msg_plain[i], e, n);
    }
}

void decrypt(int32_t d, int32_t n, int32_t msg_encr[BUFFER_SIZE], int32_t msg_plain[BUFFER_SIZE])
{
    for (size_t i = 0; i < BUFFER_SIZE; i++)
    {
        msg_plain[i] = modular_exp(msg_encr[i], d, n);
    }
}

int main()
{
    std::cout << "ENCRYPT" << std::endl;
    int32_t msg_plain[BUFFER_SIZE] = {0};
    int32_t msg_encr[BUFFER_SIZE] = {0};
    
    msg_plain[0] = 19;
    encrypt(5, 119, msg_plain, msg_encr);
    std::cout << msg_encr[0] << std::endl;

    msg_plain[0] = 0;

    std::cout << "DECRYPT" << std::endl;
    decrypt(77, 119, msg_encr, msg_plain);
    std::cout << msg_plain[0] << std::endl;
}