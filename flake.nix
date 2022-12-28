{
  description = "Based on: github.com/mitchellh/nixos-config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    mkVM = import ./lib/mkvm.nix;
    overlays = [];
  in {
    nixosConfigurations.vm-aarch64-utm = mkVM "vm-aarch64-utm" rec {
      inherit overlays nixpkgs home-manager;
      user = "pprzekwa";
      system = "aarch64-linux";
    };
  };
}
