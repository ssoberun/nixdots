{ self, inputs, ... }:
{
  flake.nixosModules.gaming =
    { pkgs, lib, ... }:
    {
      hardware.graphics.enable = lib.mkDefault true;
      hardware.steam-hardware.enable = true;
      programs = {
        steam = {
          enable = true;
          protontricks.enable = true;
          package = pkgs.steam.override {
            extraArgs = "-system-composer";
          };
        };

        gamemode = {
          enable = true;
        };
        gamescope = {
          enable = true;
        };
      };

      environment.systemPackages = with pkgs; [
        protonup-qt
        # from https://www.reddit.com/r/linux_gaming/comments/1ifkziz/howto_native_wayland_gaming_with_wine_on_nixos/
        (pkgs.lutris.override {
          # if anything goes funny this is what extraPkgs used to look like:
          # extraPkgs = pkgs: [
          extraPkgs = _: [
            pkgs.wineWow64Packages.stagingFull
            pkgs.winetricks
            # These are the ones that actually help with unarc.dll / ISDone.dll errors
            pkgs.p7zip
            pkgs.unzip
            pkgs.gnutar
            pkgs.xz
          ];
        })

        steam-run

        # gamescope
        mangohud
        r2modman
        heroic
        er-patcher

        steamtinkerlaunch
        prismlauncher

        # winetricks
        # wine-mono
        # wine-gecko

        dxvk
        lsfg-vk
        lsfg-vk-ui

      ];

      nixpkgs.overlays = [
        (_: prev: {
          openldap = prev.openldap.overrideAttrs {
            doCheck = !prev.stdenv.hostPlatform.isi686;
          };
        })
      ];
    };
}
