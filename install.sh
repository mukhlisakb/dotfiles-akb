#!/bin/bash
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo "🔍 Checking system requirements..."

# 1. Check/Install Nix
if ! command_exists nix; then
    echo "❌ Nix is not installed."
    echo "📦 Installing Nix (this will ask for your password)..."
    # Using the Determinate Systems installer which is more reliable for macOS
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    
    echo "✅ Nix installed. Sourcing nix-daemon..."
    if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi
else
    echo "✅ Nix is already installed."
fi

# 2. Check/Install nix-darwin (Bootstrap)
echo "🚀 Bootstrapping nix-darwin..."
if ! command_exists darwin-rebuild; then
    echo "⚠️ darwin-rebuild not found. Running initial switch via nix run..."
    nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake .#Vandaliciouss-MacBook-Pro
else
    echo "✅ nix-darwin already installed. Updating..."
    darwin-rebuild switch --flake .#Vandaliciouss-MacBook-Pro
fi

echo "🎉 Done! Please restart your terminal to ensure all changes take effect."
