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
    ripgrep
    git
    jq
    tldr
    tree
    wget
    bat
    fzf
    tmux
    gnused
    diff-so-fancy
    exa

    k9s
    kubectl
    kind
    stern

    vault
    libiconv

    go
    rustup
    gcc
  ];

  xdg.enable = true;
  xdg.configFile."nvim/init.lua".text = builtins.readFile ./dotfiles/nvim;

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
  };

  ### Programs
  programs.zsh = {
    enable = true;

    initExtra = builtins.readFile ./dotfiles/zshrc;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "kubectl" "kube-ps1" ];
      theme = "refined";
    };

    shellAliases = {
      ll = "exa -l";
      lll = "gls -lahF --group-directories-first";

      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";

      k = "kubectl";
      kgp = "kubectl get pods";
      kgd = "kubectl get deployments";
      ks = "kubectl -n kube-system";
      kcd = "kubectl config set-context $(kubectl config current-context) --namespace ";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
}

