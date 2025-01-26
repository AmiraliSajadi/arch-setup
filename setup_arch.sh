#!/bin/bash

# Ensure the script is run with sudo privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

echo "Updating system and synchronizing package databases..."
sudo pacman -Syu --noconfirm

# Install yay if not installed
if ! command -v yay &> /dev/null; then
  echo "Installing yay..."
  sudo pacman -S --needed --noconfirm git base-devel
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin || exit 1
  makepkg -si --noconfirm
  cd ..
  rm -rf yay-bin
else
  echo "yay is already installed."
fi

echo "Installing pacman packages..."
PACMAN_PACKAGES=(
    "neovim"
    "git"
    "kitty"
    "firefox"
    "stow"
    "python-pip"
    "noto-fonts"
    "noto-fonts-cjk"
    "noto-fonts-emoji"
    "noto-fonts-extra"
    "ttf-fira-code"
    "zsh"
    "eza"
    "fzf"
    "zoxide"
    "blueman"
    "nautilus"
)

for pkg in "${PACMAN_PACKAGES[@]}"; do
    echo "Installing $pkg..."
    sudo pacman -S --noconfirm --needed "$pkg"
done

echo "Installing AUR packages with yay..."
AUR_PACKAGES=(
    "yazi"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "btop"
    "nautilus-open-any-terminal"
    "gnome-text-editor"
    "gnome-calculator"
)

for aur_pkg in "${AUR_PACKAGES[@]}"; do
    echo "Installing $aur_pkg..."
    yay -S --noconfirm --needed "$aur_pkg"
done

# Post-install setup
echo "Applying configurations..."
# nautilus-open-any-terminal
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true
# enable bluetooth
sudo systemctl enable bluetooth
sudo systemctl start bluetooth


echo "All packages installed and configured successfully!"

