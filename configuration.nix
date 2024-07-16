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
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    config = {
      credential.helper = "libsecret";
    };
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

# Figuring out how to use the external git repo for the flake & overlays
# might be a good idea at some point to automatically catch updates.
# iohknix = builtins.fetchGit { url = "https://github.com/input-output-hk/iohk-nix/"; };

# It's unclear whether this has the intended effect.
nix.settings.extra-nix-path = (builtins.getFlake "/etc/nixos/iohk-nix/");

# There should be something somewhere to read to get an idea of how to
# form these overlay paths. The ones below didn't actually succeed.
# nix.settings.extra-nix-path = [
#       "nixpkgs-overlays=/etc/nixos/overlays/crypto/"
#       "nixpkgs-overlays=/etc/nixos/overlays/haskell-nix-crypto"
#       "nixpkgs-overlays=/etc/nixos/overlays/haskell-nix-extra"
#       "nixpkgs-overlays=/etc/nixos/overlays/rust"
#       "nixpkgs-overlays=/etc/nixos/overlays/utils"
# ];

environment.systemPackages = with pkgs; [
        alex
        autoconf
        automake
        binutils
        cabal-install
        cacert
        cargo
        cmake
        diffstat
        direnv
        dstat
        epic5
        file
        gawk
        gcc13
        gccStdenv
        haskell.compiler.ghcHEAD
        haskell.compiler.ghc910
        haskell.compiler.ghc98
        haskell.compiler.ghc96
        haskell.compiler.ghc94
        haskell.compiler.ghc92
        haskell.compiler.ghc90
        gnupg
        happy
        # hls plugins come in tiers, but they all appear to be broken.
        # It may be my own local system state vs. upstream packaging.
        # Tier 0:
        # haskellPackages.ghcide-test-utils
        haskellPackages.hls-plugin-api
        # Tier 1:
        # haskellPackages.hls-call-hierarchy-plugin
        # haskellPackages.hls-code-range-plugin
        # haskellPackages.hls-explicit-imports-plugin
        # haskellPackages.hls-pragmas-plugin
        # haskellPackages.hls-refactor-plugin
        # Tier 2:
        # haskellPackages.Cabal_3_12_0_0
        # haskellPackages.hls-alternate-number-format-plugin
        # haskellPackages.hls-cabal-plugin
        # haskellPackages.hls-cabal-fmt-plugin
        # haskellPackages.hls-change-type-signature-plugin
        # haskellPackages.hls-class-plugin
        # haskellPackages.hls-eval-plugin
        # haskellPackages.hls-explicit-fixity-plugin
        # haskellPackages.hls-fourmolu-plugin
        # haskellPackages.hls-gadt-plugin
        # haskellPackages.hls-haddock-comments-plugin
        # haskellPackages.hls-hlint-plugin
        # haskellPackages.hls-module-name-plugin
        # haskellPackages.hls-overloaded-record-dot-plugin
        # haskellPackages.hls-qualify-imported-names-plugin
        # haskellPackages.hls-selection-range-plugin
        # haskellPackages.hls-stylish-haskell-plugin
        # Tier 3:
        # haskellPackages.hls-splice-plugin
        haskell-language-server
        git
        git-credential-manager
        gnumake
        gnupg
        groff
        jq
        libsecret
        libsodium
        meson
        m4
        neovim
        ninja
        niv
        pam_gnupg
        pass
        pass-git-helper
        patchutils
        perl
        pinentry-curses
        python3
        R
        ruby
        rustc
        signing-party
        sqlite
        step-ca
        openssh
        psmisc
        time
        units
        vim # text editor, worse
        vimPlugins.nvim-treesitter-parsers.hlsplaylist
        vimPlugins.nvim-treesitter-parsers.hlsl
        vimPlugins.nvim-hlslens
        vimPlugins.auto-hlsearch-nvim
        wget
        xdg-launch
        xdg-utils
        xterm
        zlib
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
