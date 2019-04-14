import sys
import re

matrix=list('xxxxxxxxxx')

pattern=r"^(00)*"

for line in sys.stdin:
  target = line.rstrip('\n')
  match=re.match(pattern, target)
  zeros=match.group()
  target = target.lstrip(zeros)
  q=int(target, 16)
  r=0;
  b58str='';
  while q > 0:
    q, r = divmod(q, 58)
    b58str=matrix[r] + b58str
  print(zeros.replace('00', '1') + b58str)

for line in sys.stdin:
  target=line.strip('\n')
  match=re.match(pattern, target)
  ones=match.group()
  target=target.lstrip(ones)
  targetChars=list(target)
  q=0
  for c in targetChars:
    q=q*58+matrix.index(c)
  decodedHex=str(hex(q)).lstrip('0x')
  decodeHex=ones.replace('1', '00')
  hexlen=len(decodedHex)
  if hexlen % 2 == 1:
    print('0'+decodedHex)
  else:
    print(decodeHex)

