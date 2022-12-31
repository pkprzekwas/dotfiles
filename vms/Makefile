VM_NAME ?= vm-aarch64-utm

switch:
	sudo nixos-rebuild switch --flake .#${VM_NAME}

clean:
	nix-store --gc
