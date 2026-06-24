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
      ];

      insecurePackagesString = builtins.concatStringsSep "\n      " (
        map (pkg: ''"${pkg}"'') insecurePackages
      );
    in
    { pkgs, ... }:
    {
      # some code editors need the LSP installed system wide like dis
      environment.systemPackages = with pkgs; [
        nil
        nixd
      ];

      programs.ccache = {
        enable = true;
        cacheDir = "/var/cache/ccache";
      };

      nix = {
        settings = {
          substituters = [
            "https://cache.nixos.org/"
            "https://noctalia.cachix.org"
          ];

          trusted-public-keys = [
            "cache.nixos.org-1:6nCk48X65shshYpZqz0X9vRjayahF4GCednhgyXDYXk="
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
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
