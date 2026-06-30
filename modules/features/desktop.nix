{ self, lib, ... }:
{
  flake.nixosModules.desktop =
    { config, pkgs, ... }:
    {
      imports = [
        # wm
        self.nixosModules.niri
        self.nixosModules.GNOME # GNOMe as backup, and also for its apps and portals

        # latex and typst
        self.nixosModules.LaTeX
        self.nixosModules.typst
        # apps
        # self.nixosModules.firefox
        self.nixosModules.office
        self.nixosModules.discord
        self.nixosModules.beeper
        self.nixosModules.obsidian
        self.nixosModules.mpv
        self.nixosModules.zed
        self.nixosModules.aichat
        self.nixosModules.vpn
        self.nixosModules.flatpak
        self.nixosModules.gtk
        self.nixosModules.jetbrains
        self.nixosModules.vscode

        # desktop visuals
        self.nixosModules.fonts
      ];

      environment.systemPackages = with pkgs; [
        chromium
        obs-studio
        qbittorrent
      ];

      # services.qbittorrent = {
      #   enable = true;
      #   openFirewall = true;
      #   user = "sam";
      #   group = "users";
      #   torrentingPort = 8080;
      #   package = pkgs.qbittorrent;
      # };

      # services.qui = {
      #   enable = false;
      #   openFirewall = true;
      #   package = pkgs.qui;
      #   secretFile = config.sops.secrets.qui-session.path;
      # };

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

      xdg.mime = {
        enable = lib.mkDefault true;
        defaultApplications = {
          "text/html" = "firefox.desktop";
          "text/xml" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
          "x-scheme-handler/unknown" = "firefox.desktop";
        };
      };

    };
}
