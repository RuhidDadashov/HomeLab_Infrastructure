#!/bin/bash
# Install AD dependencies
sudo dnf install -y realmd sssd adcli samba-common-tools oddjob oddjob-mkhomedir
# Realm join command (user will be prompted for password)
sudo realm join -U Administrator Rdadash.local
# Enable home directory creation
sudo authselect select sssd with-mkhomedir --force
sudo systemctl enable --now sssd
