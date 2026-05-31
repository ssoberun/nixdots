{ inputs, ... }:
{
  flake.nixosModules.qt =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nwg-look
        adw-gtk3
        kdePackages.qt6ct
      ];

      programs.dconf.enable = true;

    };
}
