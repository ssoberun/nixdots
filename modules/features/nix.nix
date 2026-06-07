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

      nix = {
        settings = {
          # Enable the official NixOS cache
          substituters = [ "https://cache.nixos.org/" ];

          # Ensure your user (or all users) is allowed to use the cache
          trusted-public-keys = [ "cache.nixos.org-1:6nCk48X65shshYpZqz0X9vRjayahF4GCednhgyXDYXk=" ];

          # Set this to true to ensure Nix always checks for binaries first
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
          permittedInsecurePackages = [
            ${insecurePackagesString}
          ]
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
