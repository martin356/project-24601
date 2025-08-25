# NOT THE FINAL VERSION

update permissions to cluster dir in apparmor /etc/apparmor.d/...

inicializacia vm (instalacia kube) je v zvlast infra pretoze ip adresy boli prazdne pred vytvorenim vm
ak som zabudol vymazat nonsensitive - potrebvaol som na debugovanie

check virtualisation support
    egrep -c '(vmx|svm)' /proc/cpuinfo
    0 - no support (intel nor amd)
    >0 - support
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
sudo apt install genisoimage

sudo mkdir -p /etc/apparmor.d/abstractions/libvirt-qemu.d
echo "/var/lib/libvirt/images/** rwk," | sudo tee -a /etc/apparmor.d/abstractions/libvirt-qemu.d/override
sudo systemctl restart apparmor

run init to update kubernetes provider when vms change

master node sometimes freezes after k3s installation - probably weak vm cfg (because of my laptop weak params)

DELETE playbooks - used no more

gitguardian - 3rd party platform