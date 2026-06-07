{ self, ... }:
{
  flake.nixosModules.desktop =
    { config, pkgs, ... }:
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
        self.nixosModules.aichat
        self.nixosModules.vpn
        self.nixosModules.flatpak
        self.nixosModules.gtk

        # desktop visuals
        self.nixosModules.fonts
      ];

      environment.systemPackages = [
        pkgs.chromium
      ];
      services.qui = {
        enable = true;
        openFirewall = true;
        package = pkgs.qui;
        secretFile = config.sops.secrets.qui-session.path;
      };

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
