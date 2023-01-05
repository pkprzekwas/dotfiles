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
  }) {
    config = {
      allowUnfree = true;
      # allowUnsupportedSystem = true;
    };
  };

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
    ripgrep # better grep
    bat # better cat
    exa # better ls
    fzf # fuzzy search
    tldr # simplified man
    bottom # better sys metrics
    wget
    tree
    jq
    gnused
    diff-so-fancy

    k9s
    kubectl
    kind
    stern

    vault
    libiconv
    alacritty

    rustup
    libiconv
    gcc
  ];

  xdg.enable = true;
  xdg.configFile."nvim/init.lua".text = builtins.readFile ./dotfiles/nvim;
  xdg.configFile."alacritty/alacritty.yml".text = builtins.readFile ./dotfiles/alacritty;

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
  };

  # TODO: move tmux config to shared directory.
  home.file.".tmux.conf".source = ../vms/users/pprzekwa/dotfiles/tmux-conf;
  home.file.".tmux.conf.local".source = ../vms/users/pprzekwa/dotfiles/tmux-conf-local;

  ### Programs

  programs.go = {
    enable = true;
    goPath = "code/go";
    goPrivate = [ "github.com/pkprzekwas" ];
  };

  programs.tmux = {
    enable = true;
  };

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

  programs.git = {
    enable = true;
    userName = "Patryk Przekwas";
    userEmail = "patryk@kubermatic.com";
    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      tree = "log --graph --decorate --pretty=oneline --abbrev-commit";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      credential.helper = "store"; # want to make this more secure
      github.user = "pkprzekwas";
      push.default = "tracking";
      init.defaultBranch = "main";
      core = {
        askPass = ""; # needs to be empty to use terminal for ask pass
        editor = "nvim";
      };
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
}

