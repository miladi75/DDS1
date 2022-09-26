#include <iostream>
#include <cmath>

int32_t compute_modular_multiplicative_inverse(int32_t x, int32_t m)
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
        x = compute_modular_multiplicative_inverse(x, m);
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

// (x*e) % m
int32_t modular_mult(int32_t x, int32_t e, int32_t m)
{
    int32_t next_x = x % m;
    int32_t next_e = e % m;

    return (next_x * next_e) % m;
}

int main()
{
    int32_t res_c = compute_modular_multiplicative_inverse(17, 120);
    std::cout << res_c << std::endl;

    std::cout << "MODULAR EXPONENTIATION" << std::endl;
    int32_t res = modular_exp(17, -1, 120);
    std::cout << res << ", expect 113" << std::endl;
    res = modular_exp(50, 17, 143);
    std::cout << res << ", expect 85" << std::endl;
    res = modular_exp(85, 113, 143);
    std::cout << res << ", expect 50" << std::endl;

    std::cout << std::endl;
    std::cout << "MODULAR MULTIPLICATION" << std::endl;
    res = modular_mult(1421, 1423, 12);
    std::cout << res << ", expect 11" << std::endl;
}

/**
 * @brief This moduel implements the high level RSA algorithm
 * 
 * @return int 
 */
/*
int power(int x, int y, int p)
{
 
    // Initialize answer
    int res = 1;
 
    // Check till the number becomes zero
    while (y > 0) {
 
        // If y is odd, multiply x with result
        if (y % 2 == 1)
            res = (res * x);
 
        // y = y/2
        y = y >> 1;
 
        // Change x to x^2
        x = (x * x);
    }
    return res % p;
}

// int gcd(int a, int b){
//     int R; 
//     while((a%b)>0){
//         R = a % b;  //R=7           
//         a = b;      // a = 24
//         b = R;      //b = 7

//     }
//     return b;
// }

int main(){
    // std::cout << "gcd(8, 12) = " << gcd(8, 12) << std::endl;
    // std::cout << "gcd(79, 24) = " << gcd(79, 24) << std::endl;
    // std::cout << "gcd(42, 120) = " << gcd(42, 120) << std::endl;
    // int n, p, q, e, d, phi;
    
    // // phi = (p-1)(q-1), n = p*q

    // p = 11; q = 13;
    // n = p*q;
    // //phi(n) is Euler's totient function of n 
    // phi = (p-1)*(q-1); // (11-1)(13-1)-> 10*11 = 110
    // //d is private exponent and e is public exponent
    
    // //public exponent 1 < e < phi(n)
    // e = 7; // 
    // //get the lowest possible e to begin with
    // // while (gcd(e, phi) != 1)
    // // {
    // //     e++;

    // // }
    // d = (1/e) % n;
    // std::cout << "phi(n) = " << phi << "\nd = " << d <<std::endl;
    // double lol = fmod(1/17, 120);
    // std::cout << lol << std::endl;   
}
*/