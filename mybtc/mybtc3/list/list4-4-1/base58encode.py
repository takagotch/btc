# -*- coding: utf-8 -*-
import sys
import re

# base58変換表
matrix=list('123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz')

pattern=r"^(00)*"

# 標準入力を1行ずつ処理
for line in sys.stdin:
    target = line.rstrip('\n')              # 改行を除去
    match=re.match(pattern, target)         # ^(00)* を検索
    zeros=match.group()                     # ^(00))* を取得
    target = target.lstrip(zeros)           # ^(00)* を除去
    q=int(target, 16)                       # 商を変数qに格納
    r=0;                                    # 剰余を変数rに格納
    b58str='';                              # Base58を格納
    while q > 0:                            # 商=0まで繰り返す
        q, r = divmod(q, 58)                # 商と剰余を計算
        b58str=matrix[r] + b58str           # 剰余をBase58化して先頭に追加
    print(zeros.replace('00','1') + b58str) # 除去した00の数だけ1を先頭に追加してBase58を出力