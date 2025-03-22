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
    "hyprcursor"
    "bibata-cursor-theme-bin"
    "sddm"
    "hyprlock"
    "hyprpaper"
    "noto-fonts"
    "noto-fonts-cjk"
    "noto-fonts-emoji"
    "noto-fonts-extra"
    "ttf-fira-code"
    "zsh"
    "eza"
    "fzf"
    "zoxide"
    "wget"
    "tldr"
    "unzip"
    "zip"
    "blueman"
    "nautilus"
    "openssh"
    "wl-clipboard"
    "swww"
    "python-pywal"
    "keyd"
    "rofi-wayland"
    "flatpak"
    "ttf-firacode-nerd"
    "ttf-fira-sans"
    "wlroots"
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
    "wlogout"
    "nautilus-open-any-terminal"
    "gnome-text-editor"
    "gnome-calculator"
    "fastfetch"
    "oh-my-posh"
    "python-haishoku"
    "visual-studio-code-bin"
    "slack-desktop"
)

for aur_pkg in "${AUR_PACKAGES[@]}"; do
    echo "Installing $aur_pkg..."
    yay -S --noconfirm --needed "$aur_pkg"
done

# Post-install setup
echo "Applying configurations..."
# enable sddm
sudo systemctl enable sddm
# enable bluetooth
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
# nautilus-open-any-terminal
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true


echo "All packages installed and configured successfully!"

