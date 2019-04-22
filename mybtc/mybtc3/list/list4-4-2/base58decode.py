# -*- coding: utf-8 -*-
import sys
import re

# base58変換表
matrix=list('123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz')

pattern=r"^1*"

# 標準入力を1行ずつ処理
for line in sys.stdin:
    target=line.strip('\n')                             # 改行を除去
    match=re.match(pattern, target)                     # ^1* を検索
    ones=match.group()                                  # ^1* を取得
    target=target.lstrip(ones)                          # ^1* を除去
    targetChars=list(target)                            # 対象をcharに分解
    q=0                                                 # 商を格納する変数q
    for c in targetChars:                               # 文字毎に処理
        q=q*58+matrix.index(c)                          # 商 * 58 + 剰余
    decodedHex=str(hex(q)).lstrip('0x')                 # 16進数に変換
    decodedHex=ones.replace('1','00') + decodedHex      # 除外した 1 の数だけ 00 を先頭に追加
    hexlen=len(decodedHex)                              # 16進数の長さを取得
    if hexlen % 2 == 1:                                 # 奇数であれば、、、
        print('0'+decodedHex)                           # パディングのため、先頭に 0 を追加
    else:                                               # 偶数であれば、、、
        print(decodedHex)                               # そのまま出力
