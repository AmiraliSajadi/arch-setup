#!/bin/bash

# Check if user can sudo
if ! sudo -v; then
  echo "This script requires sudo privileges to install system packages."
  exit 1
fi

installed_packages=()
failed_packages=()

echo "Updating system and synchronizing package databases..."
sudo pacman -Syu --noconfirm

# --- Install pacman packages ---
echo ""
echo "Installing pacman packages:"
counter=1
while IFS= read -r pkg || [[ -n "$pkg" ]]; do
    echo -n "$counter. Installing $pkg... "
    if sudo pacman -S --noconfirm --needed "$pkg"; then
        echo "Installed"
        installed_packages+=("$pkg")
    else
        echo "Failed"
        failed_packages+=("$pkg")
    fi
    ((counter++))
done < pacman-packages.txt

# --- Install yay if not installed ---
if ! command -v yay &> /dev/null; then
  echo "yay not found. Installing yay..."
  sudo pacman -S --needed --noconfirm git base-devel
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin || exit 1
  makepkg -si --noconfirm
  cd ..
  rm -rf yay-bin
fi

# --- Install AUR packages without sudo ---
echo ""
echo "Installing AUR (yay) packages:"
counter=1
while IFS= read -r aur_pkg || [[ -n "$aur_pkg" ]]; do
    echo -n "$counter. Installing $aur_pkg... "
    if yay -S --noconfirm --needed "$aur_pkg"; then
        echo "Installed"
        installed_packages+=("$aur_pkg")
    else
        echo "Failed"
        failed_packages+=("$aur_pkg")
    fi
    ((counter++))
done < yay-packages.txt

# --- Summary ---
echo ""
echo "========================================"
echo "✅ Installed packages:"
echo "${installed_packages[*]}" | sed 's/ /, /g'

echo ""
echo "❌ Failed packages:"
for pkg in "${failed_packages[@]}"; do
    echo "$pkg"
done
echo "========================================"

# --- Post-install setup ---
echo ""
echo "Applying post-install configurations..."

sudo systemctl enable sddm
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# nautilus-open-any-terminal default terminal to kitty
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true

echo "All done!"
