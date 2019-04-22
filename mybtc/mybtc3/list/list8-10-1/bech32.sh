#!/bin/bash
function bech32_hrp_expand() {
        for c in $1
        do
                hrp=$hrp" $(( $((16#$(echo -n $c | xxd -p) )) >> 5))"
        done
        hrp=$hrp" 0"
        for c in $1
        do
                hrp=$hrp" $(( $((16#$(echo -n $c | xxd -p) )) & 31))"
        done
        echo $hrp
}

function bech32_convert_bits() {
        data=`echo $1 | xxd -r -p | xxd -g5 -b -c5 | cut -d " " -f2 | tr -d "\n" | sed -e "s/$/\n/" | fold -b5`
        data_int=""
        for v in $data
        do
                v=`printf %-5s $v | sed -e "s/ /0/g"`
                data_int="${data_int} $((2#$v))"
        done
        echo $data_int
}

function bech32_polymod()
{
        generator=(0x3b6a57b2 0x26508e6d 0x1ea119fa 0x3d4233dd 0x2a1462b3)
        i=0
        chk=1
        for v in $1
        do
                b=$(($chk >> 25))
                chk=$(( ( ($chk & 0x1ffffff) << 5 ) ^ $v ))
                for i in {0..4}
                do
                        if [ $(( ($b >> $i) & 1 )) -gt 0 ]; then
                                chk=$(( $chk ^ ${generator[$i]}))
                        fi
                done
        done
        echo $chk
}

function bech32_create_checksum()
{
        polymod=$(( $1 ^ 1))
        chk_int=''
        for i in {0..5}
        do
                chk_int=$chk_int" $(( ( $polymod >> (5 *(5-$i)) ) & 31))"
        done
        echo $chk_int

}

function bech32_create_address()
{
        hrp_str=$1
        hrp_array=`echo $hrp_str | fold -s1`
        witness_program=$2
        witness_version=0
        hrp=`bech32_hrp_expand "$hrp_array"`
        witness_program_ints=`bech32_convert_bits "$witness_program"`
        polymod=`bech32_polymod "$hrp $witness_version ${witness_program_ints} 0 0 0 0 0 0"`
        chk_int=`bech32_create_checksum "$polymod"`
        base32_data=`bech32_base32 "$witness_version $witness_program_ints $chk_int"`
        address=${hrp_str}${separator}${base32_data}
        echo $address
}

function bech32_base32()
{
        in=$1
        out=""
        for v in `echo "$in"`
        do
                out=${out}`echo $matrix | cut -c$(($v + 1)) | tr -d "\n"`
        done
        echo $out
}

function bech32_verify_checksum()
{
        address=$1
        hrp_str=`echo $address | cut -f 1 -d ${separator}`
        hrp_array=`echo $hrp_str | fold -s1`
        data=`echo $address | cut -f 2 -d ${separator}`
        hrp=`bech32_hrp_expand "$hrp_array"`
        data_int=''
        for c in `echo $data | fold -b1`
        do
                data_int=${data_int}"`echo $(( $(echo $matrix | fold -b1 | grep -n $c | cut -f 1 -d ":") -1 ))` "
        done
        ret=`bech32_polymod "$hrp $data_int"`
        echo $ret
}

# エントリーポイント
in=`cat -`;
p=`echo $in | cut -f 1 -d " "`
matrix="qpzry9x8gf2tvdw0s3jn54khce6mua7l"
separator="1"
if [ $p == "create" ]; then # 第一引数が create ならアドレスを生成する
        hrp_str=`echo $in | cut -f 2 -d " "` # bcなどの human-readable part を第二引数から取得
        witness_program=`echo $in | cut -f 3 -d " "` # witness program を第三引 数から取得
        address=`bech32_create_address "$hrp_str" "$witness_program"`
        echo $address
elif [ $p == "verify" ]; then # 第一引数が verify ならアドレスを検証する
        address=`echo $in | cut -f 2 -d " "` # アドレスを第二引数から取得
        ret=`bech32_verify_checksum "$address"`
        echo $ret # 1なら検証に成功。1以外ならアドレスに間違いがある
else
        exit 1
fi
