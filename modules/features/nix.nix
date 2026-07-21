{
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.nix =
    let
      insecurePackages = [
        "electron-39.8.10"
        "nodejs-20.20.2"
        "ventoy"
        "vivaldi"
        "pnpm-10.29.2"
      ];

      insecurePackagesString = builtins.concatStringsSep "\n      " (
        map (pkg: ''"${pkg}"'') insecurePackages
      );
    in
    { pkgs, ... }:
    {
      # nix LSP needs to be installed system wide for some code editors...
      environment.systemPackages = with pkgs; [
        nil
        nixd
      ];

      programs.ccache = {
        enable = true;
        cacheDir = "/var/cache/ccache";
      };

      programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
          dbus
        ];
      };

      nix = {
        settings = {
          substituters = [
            "https://cache.nixos.org/"
            # noctalia cache
            "https://noctalia.cachix.org"
            # nix-community cache includes unfree but redist. pkgs: https://nix-community.org/cache/
            "https://nix-community.cachix.org"
            # driver cache
            "https://cache.nixos-cuda.org"
          ];

          trusted-public-keys = [
            "cache.nixos.org-1:6nCk48X65shshYpZqz0X9vRjayahF4GCednhgyXDYXk="
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
          ];

          substitute = true;

          # slows down builds, use nix.optimise instead
          # auto-optimise-store = true;

          experimental-features = [
            "nix-command"
            "flakes"
          ];
        };

        optimise = {
          automatic = true;
          dates = [ "03:45" ];
        };

        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 14d";
        };

      };

      boot.loader.systemd-boot.configurationLimit = 10;

      # nixpkgs configs

      nixpkgs.config = {
        allowUnfree = true;
        permittedInsecurePackages = insecurePackages;
      };

      hj.xdg.config.files."nixpkgs/config.nix".source = pkgs.writeText "nixpkgs-config" /* nix */ ''
        {
          allowUnfree = true;
          permittedInsecurePackages = [
            ${insecurePackagesString}
          ];
        }

      '';

      # hj.xdg.config.files."nixpkgs/config.nix" = {
      #   value = /* nix */ ''
      #     {
      #       permittedInsecurePackages = [
      #           "electron-39.8.10"
      #         ];
      #     }
      #   '';
      # };
    };
}
