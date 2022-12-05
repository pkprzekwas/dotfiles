{ config, pkgs, libs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = "patrykprzekwas";
  home.homeDirectory = "/Users/patrykprzekwas";

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
  ];

}
