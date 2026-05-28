{ self, ... }:
{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      imports = [
        # wm
        self.nixosModules.niri
        self.nixosModules.GNOME # GNOMe as backup, and also for its apps and portals

        # latex
        self.nixosModules.LaTeX
        # apps
        # self.nixosModules.firefox
        self.nixosModules.discord
        self.nixosModules.beeper
        self.nixosModules.obsidian
        self.nixosModules.mpv
        self.nixosModules.zed

        # desktop visuals
        self.nixosModules.fonts
      ];

      programs.localsend = {
        enable = true;
        openFirewall = true; # opens port 53317 for TCP and UDP
      };

      # chromium test

      programs.chromium = {
        enable = true;
      };

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # Standard for most DEs/WMs
        config.common.default = "*"; # Ensures a fallback portal is used
      };

    };
}
