sudo tee /etc/systemd/system/netplan-apply-onboot.service >/dev/null <<'EOF'
[Unit]
Description=Run 'netplan apply' once at each boot
ConditionPathExistsGlob=/etc/netplan/*.yaml
After=cloud-init.service systemd-udev-settle.service
Wants=systemd-udev-settle.service
Before=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/netplan apply

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable netplan-apply-onboot.service