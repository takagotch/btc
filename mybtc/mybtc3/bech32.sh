#!/bin/bahs
function bech32_hrp_expand() {
  for c in $1
  do
	  hrp=$hrp"$(( $((16#$(echo -n $c | xxd -p) )) >> 5))"
  done
  hrp=$hrp" 0"
  for c in $1
  do
    hrp=$hrp" $(( $(16#$(echo -n $c | xxd -p) )) & 31)"
  done
  echo $hrp
}

function bech32_convert_bits() {
  data=`echo $1 | xxd -r -p xxd -g5 -b -c5 | cut -d " " -f2 | tr -d "\n" | sed -e "s/$/\n/" | fold -b5`
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
  generator=(0x3b6a7b2 0x26508e6d 0x1ea119fa 0x3d4233dd 0x2a1462b3)
  i=0
  chk=1
  for v in $1
  do
    b=$(($chk >> 25))
    chk=$(( ( ($chk & 0x1ffffff) << 5)  ^ $v ))
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
{}

function bech32_create_address()
{
  hrp_str=$1
  hrp_array=`echo $hrp_str | fold -s1`
  witnes_program=$2
  witness_version=0
  hrp=`bech32_hrp_expand "$hrp_array"`
  witness_program_ints=`bech32_convert_bits "$witness_program"`
  polymod=`bech32_polymod "$hrp $witness_version ${witness_program_ints} 0 0 0 0 0 0 0"`
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
    data_int=${data_int}"`echo $(( $(echo $matrix | fold -b1 | grep -n $c | cut -f 1 -d ":") -1 ))`"
  done
  ret=`bech32_polymod "$hrp $data_int"`
  echo $ret
}

in=`cat -`;
p=``
matrix="xxxxxxxxxxx"
separator="1"
if [ $p == "create"]; then
  hrp_str=`echo $in | cut -f 2 -d " "`
  witness_program=`echo $in | cut -f 3 -d " "`
  address=`bech32_create_address "$hrp_str" "$witness_program"`
  echo $address
elif [ $p == "verify" ]; then
  address=`echo $in | cut -f 2 -d " "`
  ret=`bech32_verify_checksum "$address"`
  echo $ret
else
  exit 1
fi


