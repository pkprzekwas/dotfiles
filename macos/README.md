# Macbook

For the time being I don't use Flakes for my MacOS setup.

## One time setup

1. Install nix: `https://nixos.org/download.html#nix-install-macos`
2. Clone the repo: 
```
git clone git@github.com:pkprzekwas/dotfiles.git ~/dotfiles
```
3. Setup channels before installing home-manager:
```
nix-channel --add https://channels.nixos.org/nixos-21.11 nixpkgs
nix-channel --update
```
4. Install home-manager.
```
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
nix-shell '<home-manager>' -A install

```
5. Create symlink and generate local environment.
```
mkdir -p ${HOME}/.config/nixpkgs/
ln -s -f ~/pkprzekwas/dotfiles/macos/home.nix ${HOME}/.config/nixpkgs/home.nix
home-manager switch
```
