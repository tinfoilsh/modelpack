#!/bin/bash
set -e

MPK=$1
INFO=$2

if [ ! -f "$MPK" ]; then
    echo "MPK device not found"
    exit 1
fi

root_hash=$(echo $INFO | cut -d '-' -f 1)
offset=$(echo $INFO | cut -d '-' -f 2)
device_name="mpk-$root_hash"

veritysetup open \
    $MPK \
    $device_name \
    $MPK \
    $root_hash \
    --hash-offset=$offset

echo mount -o ro /dev/mapper/$device_name /mnt
