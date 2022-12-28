{
  description = "Flake config";


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = { nixpkgs, home-manager, ... }:
  let
    user = "pprzekwa";
    system = "aarch64-linux";

    pkgs = import nixpkgs {
      inherit system;

      config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;

  in {
    nixosConfigurations = {

      utm = lib.nixosSystem {
        inherit system;

        modules = [
          ./system/configuration.nix
        ];

      };

    };

  };

}
