#!/bin/bash

virsh -c qemu:///system destroy theproject-dev-master
virsh -c qemu:///system undefine theproject-dev-master --remove-all-storage

virsh -c qemu:///system destroy theproject-dev-worker-0
virsh -c qemu:///system undefine theproject-dev-worker-0 --remove-all-storage

virsh -c qemu:///system destroy theproject-dev-worker-1
virsh -c qemu:///system undefine theproject-dev-worker-1 --remove-all-storage

virsh -c qemu:///system net-destroy theproject-dev-net
echo "Network interface deletion requires sudo"
sudo rm -f /var/lib/libvirt/dnsmasq/theproject-dev-net.*
virsh -c qemu:///system net-undefine theproject-dev-net
