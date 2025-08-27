#!/bin/bash

set -euo pipefail

MACHINES="$(printf '%s' 'dGhlcHJvamVjdC1kZXYtZ2l0aHViLXJ1bm5lcix0aGVwcm9qZWN0LWRldi1tYXN0ZXIsdGhlcHJvamVjdC1kZXYtd29ya2VyLTAsdGhlcHJvamVjdC1kZXYtd29ya2VyLTE=' | base64 -d)"
SEPARATOR=","

IFS="$SEPARATOR" read -ra machines_list <<< "$MACHINES"

for m in "${machines_list[@]}"; do
    echo "Shutdown $m"
    virsh -c qemu:///system shutdown $m
done
