{ pkgs, ... }:

{
  users.users.pprzekwa = {
    isNormalUser = true;
    home = "/home/pprzekwa";
    extraGroups = [ "docker" "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  nixpkgs.overlays = import ../../lib/overlays.nix ++ [];
}

