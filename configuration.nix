# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nyc";
  users.users.nyc.isNormalUser = true;

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
     enable = true;
     pinentryPackage = pkgs.pinentry-curses;
     enableSSHSupport = true;
  };
  programs.zsh.enable = true;
  programs.direnv = {
    enable = true;
    direnvrcExtra = ''
    echo "loaded direnv!"
    '';
  };
  users.users.nyc.shell = pkgs.zsh;
  

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # This stopped working: https://cache.zw3rk.com
  system.stateVersion = "23.05"; # Did you read the comment?
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    extra-substituters = https://cache.iog.io
    extra-trusted-public-keys = hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= loony-tools:pr9m4BkM/5/eSTZlkQyRt57Jz7OMBxNSUiMC4FkcNfk=
  '';

nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

environment.systemPackages = with pkgs; [
        alex
        binutils
        cargo
        direnv
        epic5
        gcc
        ghc
        gnupg
        happy
        cabal-install
        git
        gnumake
        pass-git-helper
        patchutils
        pinentry-curses
        rustc
        sqlite
        openssh
        psmisc
        vim # text editor, worse
        wget
        zsh
];

#  builtins.fetchGit { url = "https://github.com/nix-community/NUR" };
#  with import (builtins.fetchTarball {
#    # Get the revision by choosing a version from https://github.com/nix-community/NUR/commits/master
#    url = "https://github.com/nix-community/NUR/archive/3a6a6f4da737da41e27922ce2cfacf68a109ebce.tar.gz";
#    # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
#    sha256 = "04387gzgl8y555b3lkz9aiw9xsldfg4zmzp930m62qw8zbrvrshd";
#  }) {};


#  programs.git = {
#    enable = true;
#    # ...
#    extraConfig = {
#      credential = {
#        credentialStore = "secretservice";
#        helper = "${nur.repos.utybo.git-credential-manager}/bin/git-credential-manager-core";
#      };
#    };
#  };
}
