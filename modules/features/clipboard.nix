{
  flake.nixosModules.core = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      wl-clipboard
      wl-clipboard-x11
      ripgrep
      fd
    ];

    # 2. Create a background service to sync Wayland -> X11 clipboards
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
  };
}
