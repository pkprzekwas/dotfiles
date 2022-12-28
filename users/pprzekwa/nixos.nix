{ pkgs, ... }:

{
  # https://github.com/nix-community/home-manager/pull/2408
  #environment.pathsToLink = [ "/share/fish" ];

  users.users.pprzekwa = {
    isNormalUser = true;
    home = "/home/pprzekwa";
    extraGroups = [ "docker" "wheel" "networkmanager" ];
    shell = pkgs.bash;
  };

  nixpkgs.overlays = import ../../lib/overlays.nix ++ [];
}

