# #!/usr/bin/env bash

set -eu

if virsh net-dumpxml "$NET_NAME" | grep "mac='$VM_MAC'"
then
  echo "The lease reservation for $VM_NAME already exists"
else
  echo "Create lease reservation for $VM_NAME - $VM_MAC - $VM_IP"
  virsh net-update $NET_NAME add-last ip-dhcp-host \
    "<host mac='$VM_MAC' ip='$VM_IP' name='$VM_NAME'/>" \
    --live --config
fi
