#include <cstdio>
#include <cstdint>
#include <cmath>

uint64_t modular_mult(uint64_t a, uint64_t b, uint64_t n)
{
    uint64_t r, k;

    k = floor(log2(b)) + 1;
    r = 0;

    for (uint64_t i = 0; i < k; i++)
    {
        uint64_t mask = 1 << (k - i - 1);
        r = 2 * r + a * ((b & mask) >> (k - i - 1));
        
        if (r >= n)
        {
            r = r - n;
        }
        if (r >= n)
        {
            r = r - n;
        }
    }

    return r;
}

uint64_t modular_exp(uint64_t m, uint64_t e, uint64_t n)
{
    uint64_t c, p, k;

    k = floor(log2(e)) + 1;
    c = 1;
    p = m;

    for (uint64_t i = 0; i < k; i++)
    {
        uint64_t mask = 1 << i;
        if ((e & mask) == mask)
        {
            c = modular_mult(c, p, n);
        }
        p = modular_mult(p, p, n);
    }

    return c;
}

int main()
{
    uint64_t res = modular_exp(19, 5, 119);
    printf("%lu\n", res);
    res = modular_exp(66, 77, 119);
    printf("%lu\n", res);
}