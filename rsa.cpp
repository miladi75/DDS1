#include <iostream>
#include <cmath>

#define BUFFER_SIZE 256

int32_t modular_multiplicative_inverse(int32_t x, int32_t m)
{
    int32_t t = 0;
    int32_t r = m;
    int32_t next_t = 1;
    int32_t next_r = x;

    while (next_r != 0)
    {
        int32_t tmp = r / next_r;

        int32_t saved_t = t;
        t = next_t;
        next_t = saved_t - tmp * next_t;

        int32_t saved_r = r;
        r = next_r;
        next_r = saved_r - tmp * next_r;
    }

    if (r > 1)
    {
        exit(-1);
    }
    if (t < 0)
    {
        t = t + m;
    }

    return t;
}

// (x^e) % m
int32_t modular_exp(int32_t x, int32_t e, int32_t m)
{
    if (m == 1)
    {
        return 0;
    }

    // OPTIONAL (only to compute with negative e)
    if (e < 0)
    {
        x = modular_multiplicative_inverse(x, m);
        e = -e;
    }
    // END OPTIONAL

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
    std::cout << "MODULAR EXPONENTIATION" << std::endl;
    int32_t res = modular_exp(17, -1, 120);
    std::cout << res << ", expect 113" << std::endl;
    res = modular_exp(50, 17, 143);
    std::cout << res << ", expect 85" << std::endl;
    res = modular_exp(85, 113, 143);
    std::cout << res << ", expect 50" << std::endl;

    std::cout << std::endl;
    std::cout << "ENCRYPT" << std::endl;
    int32_t msg_plain[BUFFER_SIZE] = {0};
    int32_t msg_encr[BUFFER_SIZE] = {0};
    
    msg_plain[0] = 19;
    encrypt(5, 119, msg_plain, msg_encr);
    std::cout << msg_encr[0] << std::endl;

    msg_plain[0] = 0;

    std::cout << "DECRYPT" << std::endl;
    decrypt(5, 119, msg_encr, msg_plain);
    std::cout << msg_plain[0] << std::endl;
}