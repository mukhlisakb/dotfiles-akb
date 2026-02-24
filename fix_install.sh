#!/bin/bash
set -e

# --- Helper Functions ---
log() { echo "👉 $1"; }
warn() { echo "⚠️  $1"; }
error() { echo "❌ $1"; exit 1; }

# Ensure sudo
if ! command -v sudo >/dev/null 2>&1; then
    error "sudo is required but not found."
fi

log "Requesting sudo permissions..."
sudo -v
# Keep sudo alive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# --- 1. Diagnostics ---
log "Starting Diagnostics..."

check_nix_installed() {
    if command -v nix >/dev/null 2>&1; then
        log "Nix is installed: $(nix --version)"
        return 0
    else
        warn "Nix is NOT installed or not in PATH."
        return 1
    fi
}

check_nix_darwin() {
    if [ -e "/etc/nix-darwin" ] || [ -e "/run/current-system" ]; then
        warn "Nix-Darwin artifacts detected."
        return 0
    else
        log "No Nix-Darwin artifacts found."
        return 1
    fi
}

check_nix_volume() {
    if mount | grep -q " on /nix "; then
        warn "/nix is mounted."
        return 0
    else
        if [ -d "/nix" ]; then
            warn "/nix exists but is NOT mounted (possibly read-only root artifact)."
            return 1 # Exists but not mounted
        else
            log "/nix does not exist."
            return 2 # Does not exist
        fi
    fi
}

# --- 2. Fix / Cleanup ---
log "Starting Cleanup & Fix..."

# Stop Daemons
log "Stopping Nix daemons..."
sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist 2>/dev/null || true
sudo launchctl unload /Library/LaunchDaemons/systems.determinate.nix-installer.plist 2>/dev/null || true
sudo rm -f /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo rm -f /Library/LaunchDaemons/systems.determinate.nix-installer.plist

# Remove Nix-Darwin blockers (Must be done before Nix uninstall)
log "Removing Nix-Darwin artifacts..."
sudo rm -rf /etc/nix-darwin
sudo rm -rf /run/current-system
sudo rm -rf /etc/static
sudo rm -rf /nix/var/nix/profiles/system

# Unmount /nix if mounted
if mount | grep -q " on /nix "; then
    log "Unmounting /nix..."
    sudo diskutil unmount force /nix || warn "Failed to unmount /nix"
fi

# Remove 'Nix Store' APFS Volume
NIX_DISK=$(diskutil list | grep "Nix Store" | awk '{print $NF}')
if [ -n "$NIX_DISK" ]; then
    log "Removing APFS Volume 'Nix Store' ($NIX_DISK)..."
    sudo diskutil apfs deleteVolume "$NIX_DISK" || warn "Failed to delete volume"
fi

# Clean /etc/synthetic.conf
if [ -f "/etc/synthetic.conf" ]; then
    log "Cleaning /etc/synthetic.conf..."
    # Backup
    sudo cp /etc/synthetic.conf /etc/synthetic.conf.bak
    # Remove 'nix' line
    sudo sed -i.bak '/^nix/d' /etc/synthetic.conf
    # Remove empty file
    if [ ! -s "/etc/synthetic.conf" ]; then
        sudo rm -f "/etc/synthetic.conf"
    fi
fi

# Clean /etc/fstab
if [ -f "/etc/fstab" ]; then
    log "Cleaning /etc/fstab..."
    sudo cp /etc/fstab /etc/fstab.bak
    sudo sed -i.bak '/Nix Store/d' /etc/fstab
    if [ ! -s "/etc/fstab" ]; then
        sudo rm -f "/etc/fstab"
    fi
fi

# Clean Shell Configs
log "Cleaning shell configs..."
clean_shell() {
    local file="$1"
    if [ -f "$file" ]; then
        sudo sed -i.bak '/nix-daemon.sh/d' "$file"
        sudo sed -i.bak '/nix-darwin/d' "$file"
        sudo sed -i.bak '/# Nix/d' "$file"
        sudo sed -i.bak '/# End Nix/d' "$file"
    fi
}
clean_shell "/etc/zshrc"
clean_shell "/etc/bashrc"
clean_shell "/etc/profile"
clean_shell "$HOME/.zshrc"
clean_shell "$HOME/.zprofile"

# Remove /nix directory (if possible)
# Note: On macOS Catalina+, root is read-only. We can't rm -rf /nix if it's on root.
# But if it was synthetic, removing it from synthetic.conf + reboot usually clears it.
# We can try to remove it just in case it's on Data volume.
if [ -d "/nix" ]; then
    log "Attempting to remove /nix directory..."
    sudo rm -rf /nix 2>/dev/null || warn "Could not remove /nix (expected if on Read-Only root). It should be gone after reboot or hidden by new mount."
fi

# --- 3. Install Nix ---
log "Installing Nix (Determinate Systems)..."
# Using Determinate Systems installer because it's robust and handles macOS volumes well
if curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm; then
    log "✅ Nix installed successfully!"
else
    error "❌ Nix installation failed."
fi

# Source nix for current session
if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
    . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi

# --- 4. Install Nix-Darwin ---
log "Installing Nix-Darwin..."

# Check if we have the flake
if [ ! -f "flake.nix" ]; then
    error "flake.nix not found in current directory!"
fi

# Run the install command
log "Running darwin-rebuild..."
if nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake .#Vandaliciouss-MacBook-Pro; then
    log "✅ Nix-Darwin installed successfully!"
else
    error "❌ Nix-Darwin installation failed."
fi

log "🎉 All done! Please restart your terminal."
