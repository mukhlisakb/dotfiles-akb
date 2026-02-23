# Makefile for Nix Darwin configuration

# Detect hostname
HOSTNAME := $(shell hostname -s)

# Default target
.PHONY: all
all: switch

# Bootstrap the configuration (use this for the first time)
.PHONY: bootstrap
bootstrap:
	nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake .#$(HOSTNAME)

# Apply configuration
.PHONY: switch
switch:
	darwin-rebuild switch --flake .#$(HOSTNAME)

# Check configuration
.PHONY: check
check:
	nix --extra-experimental-features "nix-command flakes" flake check

# Update flake inputs
.PHONY: update
update:
	nix --extra-experimental-features "nix-command flakes" flake update

# Garbage collect
.PHONY: gc
gc:
	nix-collect-garbage -d

# Show flake outputs
.PHONY: show
show:
	nix --extra-experimental-features "nix-command flakes" flake show
