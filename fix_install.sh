#!/bin/bash
set -e

# Ensure sudo is available and refresh credentials
if ! command -v sudo >/dev/null 2>&1; then
    echo "❌ sudo is required but not found."
    exit 1
fi

echo "🔐 Requesting sudo permissions for deep cleaning..."
sudo -v

# Keep sudo alive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "🧹 Starting deep cleanup of Nix and Nix-Darwin..."

# --- 1. Stop Services ---
echo "🛑 Stopping Nix daemons..."
sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist 2>/dev/null || true
sudo launchctl unload /Library/LaunchDaemons/systems.determinate.nix-installer.plist 2>/dev/null || true
sudo rm -f /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo rm -f /Library/LaunchDaemons/systems.determinate.nix-installer.plist

# --- 2. Remove Nix-Darwin Artifacts (Critical for Uninstaller) ---
echo "🗑️  Removing Nix-Darwin markers..."
sudo rm -rf /etc/nix-darwin
sudo rm -rf /run/current-system
sudo rm -rf /etc/static
sudo rm -rf /nix/var/nix/profiles/system

# --- 3. Handle /nix Volume ---
echo "💾 Handling /nix volume..."
if mount | grep -q " on /nix "; then
    echo "   Unmounting /nix..."
    sudo diskutil unmount force /nix || echo "   Warning: Could not unmount /nix"
fi

# Try to find and delete the APFS volume labeled 'Nix Store'
NIX_DISK=$(diskutil list | grep "Nix Store" | awk '{print $NF}')
if [ -n "$NIX_DISK" ]; then
    echo "   Deleting APFS volume $NIX_DISK..."
    sudo diskutil apfs deleteVolume "$NIX_DISK" || echo "   Warning: Could not delete volume $NIX_DISK"
fi

# If /nix still exists as a directory (and not a mountpoint), remove it
if [ -d "/nix" ] && ! mount | grep -q " on /nix "; then
    echo "   Removing /nix directory..."
    sudo rm -rf /nix
fi

# --- 4. Clean Configuration Files ---
echo "📝 Cleaning system configuration files..."

# /etc/synthetic.conf
if [ -f "/etc/synthetic.conf" ]; then
    sudo sed -i.bak '/^nix$/d' /etc/synthetic.conf
    # If empty, remove it
    if [ ! -s "/etc/synthetic.conf" ]; then
        sudo rm -f "/etc/synthetic.conf"
    fi
fi

# /etc/fstab
if [ -f "/etc/fstab" ]; then
    sudo sed -i.bak '/Nix Store/d' /etc/fstab
    # If empty, remove it
    if [ ! -s "/etc/fstab" ]; then
        sudo rm -f "/etc/fstab"
    fi
fi

# /etc/nix
sudo rm -rf /etc/nix

# --- 5. Clean Shell Configs ---
echo "🐚 Cleaning shell configurations..."
clean_shell_file() {
    local file="$1"
    if [ -f "$file" ]; then
        # Check for nix-daemon or nix-darwin hooks
        if grep -q "nix-daemon.sh" "$file" || grep -q "nix-darwin" "$file"; then
            echo "   Cleaning $file..."
            sudo sed -i.bak '/nix-daemon.sh/d' "$file"
            sudo sed -i.bak '/nix-darwin/d' "$file"
            sudo sed -i.bak '/# Nix/d' "$file"
            sudo sed -i.bak '/# End Nix/d' "$file"
        fi
        
        # Restore backup if it exists and original is now empty or just generic
        local backup="$file.backup-before-nix-darwin"
        if [ -f "$backup" ]; then
            echo "   Restoring $file from backup..."
            sudo mv "$backup" "$file"
        fi
    fi
}

clean_shell_file "/etc/zshrc"
clean_shell_file "/etc/bashrc"
clean_shell_file "/etc/profile"
# Also check user dotfiles lightly (optional, but good for completeness)
# clean_shell_file "$HOME/.zshrc"
# clean_shell_file "$HOME/.bashrc"
# clean_shell_file "$HOME/.zprofile"

# --- 6. Remove Users/Groups (Optional but cleaner) ---
echo "bust_cache" # dummy echo to ensure next command runs
# Nix installer usually creates _nixbld groups and users. 
# We'll leave them for now as they don't block re-installation usually, 
# and removing them is tedious/risky.

echo "✅ Deep cleanup complete."
echo "🔄 Restarting installation..."

./install.sh
