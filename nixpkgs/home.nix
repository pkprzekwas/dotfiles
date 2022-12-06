{ config, ... }:

let
  username = builtins.getEnv "USER";
  homeDir = builtins.getEnv "HOME";

  # pin stable and unstable channels to specific commits
  stable = "527bba34acb1235fed50eab49c627f14de15cc55";
  unstable = "a2d2f70b82ada0eadbcb1df2bca32d841a3c1bf1";

  pkgs = import (builtins.fetchGit {
    name = "nixpkgs-stable";
    url = "https://github.com/nixos/nixpkgs.git";
    ref = "refs/heads/nixpkgs-22.11-darwin";
    rev = "${stable}";
  }) { config = { allowUnfree = true; }; };

  pkgs_unstable = import (builtins.fetchGit {
    name = "nixpkgs-unstable";
    url = "https://github.com/nixos/nixpkgs.git";
    ref = "refs/heads/nixpkgs-unstable";
    rev = "${unstable}";
  }) {
    config = { allowUnfree = true; };
    overlays = [
      (self: super: {

      })
    ];
  };

in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = username;
  home.homeDirectory = homeDir;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    bottom
    tree
    neovim
    ripgrep
    git
    jq
    tldr
    tree
    wget
    k9s
    kubectl
    vault
    bat
    fzf
    zsh
    tmux
    stern
    diff-so-fancy
    sqlite
    kind
  ];
}
