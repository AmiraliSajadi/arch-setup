#!/bin/bash

echo ""
echo "Applying post-install configurations..."

USERNAME=$(whoami)

# Set default shell to zsh
chsh -s $(which zsh)

# Automatic login after boot up
# You will only rely on decription afterward to login after a boot!
OVERRIDE_DIR="/etc/systemd/system/getty@tty1.service.d"
OVERRIDE_FILE="${OVERRIDE_DIR}/override.conf"
sudo mkdir -p "$OVERRIDE_DIR"
# Write the override config with autologin
sudo tee "$OVERRIDE_FILE" > /dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $USERNAME --noclear %I \$TERM
EOF
# Reload systemd and enable the service
sudo systemctl daemon-reexec
sudo systemctl enable getty@tty1.service

# Enable & start bluetooth
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# nautilus-open-any-terminal default terminal to kitty
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true

# TODO: Stow all configurations


# Set a wallpaper
set-wall golden_gate.jpg

echo "All done!"
echo "Please log out or reboot the system for all changes to take place."
