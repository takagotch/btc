echo 01 | sha256d
echo 02 | sha256d

cd !/work/mywallet
python3
import modinv as m
n=xxx
k=xxx
rx=0xdbxxx
mlhash=0xxxx
m2hash=0xxxx
d=0xxxx

r = rx % n
s1 = (m1hash + d * r) * m.multiply_inv(k, n) % n
s2 = (m2hash + d * r) * m.multiply_inv(k, n) % n

derived_d = (s2 * mlhash - s1 * m2hash) * m.multiply_inv((s1-s2) * r, n) % n
derived_d
d == derived_d






