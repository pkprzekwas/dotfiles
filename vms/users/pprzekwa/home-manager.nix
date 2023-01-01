{ config, lib, pkgs, ... }:

let sources = import ../../nix/sources.nix; in {
  # Home-manager 22.11 requires this be set. We never set it so we have
  # to use the old state version.
  home.stateVersion = "18.09";

  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = with pkgs; [
    chromium
    firefox
    rofi

    bat
    fd
    fzf
    htop
    jq
    unzip
    ripgrep
    tree
    watch
    zathura
    tldr
    bottom
    alacritty

    stern
    kubectl
    kind

    go
    rustup
    nodejs
  ];

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
  };

  home.file.".inputrc".source = ./dotfiles/inputrc;
  home.file.".tmux.conf".source = ./dotfiles/tmux-conf;
  home.file.".tmux.conf.local".source = ./dotfiles/tmux-conf-local;

  xdg.configFile."i3/config".text = builtins.readFile ./dotfiles/i3;
  xdg.configFile."rofi/config.rasi".text = builtins.readFile ./dotfiles/rofi;
  xdg.configFile."devtty/config".text = builtins.readFile ./dotfiles/devtty;
  xdg.configFile."nvim/init.lua".text = builtins.readFile ./dotfiles/nvim-init;
  xdg.configFile."alacritty/alacritty.yml".text = builtins.readFile ./dotfiles/alacritty;

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./dotfiles/kitty;
  };

  programs.gpg.enable = true;

  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [ "ignoredups" "ignorespace" ];
    initExtra = builtins.readFile ./dotfiles/bashrc;

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gp = "git push";
      gs = "git status";
      gt = "git tag";
    };
  };

  programs.git = {
    enable = true;
    userName = "Patryk Przekwas";
    userEmail = "pkprzekwas@gmail.com";
    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "pkprzekwas";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  };

  programs.go = {
    enable = true;
    goPath = "code/go";
    goPrivate = [ "github.com/pkprzekwas" ];
  };

  programs.tmux = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "tty";

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  xresources.extraConfig = builtins.readFile ./dotfiles/Xresources;

  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
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

}
