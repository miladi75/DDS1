#include <iostream>
#include <stdio.h>
#include<math.h>

/**
 * @brief This moduel implements the high level RSA algorithm
 * 
 * @return int 
 */

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