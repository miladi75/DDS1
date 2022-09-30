from re import M
from bitstring import BitArray

n_key = 119
e_key_s = 5
d_key_s = 77
k = 8

def to_array(c):
    x = str(bin(c)[2:])
    while len(x) < k:
        x = "0"+x
    return x

def blakley(a, b, n):
    R = 0
    for i in range(len(a)-1, -1, -1):
        R = 2*R
        if a[i] == "1" : R = R+b
        if R >= n:
            R = R-n
        if R >= n:
            R = R-n

    return R

def binary(m, e, n):
    if e[-1] == "1":
        C=m
    else:
        C=1

    for i in range(len(e)-2, -1, -1):
       C = blakley(to_array(C), C, n)
       if e[i] =="1" : C = blakley(to_array(C), m, n)
    
    return C

e_key = to_array(e_key_s)
d_key = to_array(d_key_s)

msg = 20
cipher = binary(msg, e_key, n_key)
print(cipher)
decipher = binary(cipher, d_key, n_key)
print(decipher)