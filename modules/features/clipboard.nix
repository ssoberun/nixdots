{
  flake.nixosModules.core = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      wl-clipboard
      wl-clipboard-x11
      ripgrep
      fd
      clipnotify
    ];

    systemd.user.services.wayland-to-x11-clipboard = {
      description = "Sync Wayland clipboard to X11 (Xwayland/Wine)";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.xclip}/bin/xclip -selection clipboard";
        Restart = "always";
        RestartSec = 5;
      };
    };

    systemd.user.services.x11-to-wayland-clipboard = {
      description = "Sync X11 to Wayland clipboard (Xwayland/Wine)";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      serviceConfig = {
        # ExecStart = "${pkgs.xclip}/bin/xclip -selection clipboard -l 0 -o -f";
        # StandardOutput = "file:/run/user/%U/wl-copy-pipe";
        ExecStart = "${pkgs.clipnotify}/bin/clipnotify -w -l ${pkgs.wl-clipboard}/bin/wl-paste -n";
        Restart = "always";
        RestartSec = 5;
      };
    };
  };
}
