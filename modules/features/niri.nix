{ self, inputs, ... }:
{
  flake.nixosModules.niri =
    {
      self',
      pkgs,
      config,
      ...
    }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
        # package = self'.packages.niri;
      };

      # from iynaix on the vimjoyer discord server
      # do not kick me out of a session on rebuild
      systemd.user.units."niri.service" = {
        # add to the existing service, as drop-in so it doesn't generate the other sections
        overrideStrategy = "asDropin";
        text = ''
          [Service]
          X-StopIfChanged=false
          X-RestartIfChanged=false
        '';
      };
      # systemd.user.services.niri = {
      #   # add to the existing service, drop-in so it doesn't genreate the other sections
      #   overrideStrategy = "asDropin";
      #   stopIfChanged = false;
      #   restartIfChanged = false;
      # };
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      config,
      ...
    }:
    {
      packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        disableConfigHotReload = false;
        settings =
          let
            MainMod = "Mod";
            noctaliaExe = lib.getExe self'.packages.noctalia-shell;
            terminalExe = lib.getExe self'.packages.terminal;
            wlrWhichKeyExe = lib.getExe self'.packages.wlr-which-key;
            # fcitx5Exe = lib.getExe pkgs.fcitx5;
          in
          {
            spawn-at-startup = [
              noctaliaExe
            ];

            xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

            cursor = {
              xcursor-theme = "macOS";
              xcursor-size = 28;
            };

            input = {
              keyboard.xkb.layout = "us";
              mouse.accel-profile = "flat";
            };

            outputs."eDP-1" = {
              scale = 1.0;
              variable-refresh-rate = _: { };
            };

            layout = {
              gaps = 3;
              # focus-ring = {
              #   off = _: { };
              # };
              border = {
                width = 1;
              };
            };
            #
            switch-events = {
              lid-open = _: {
                content = {
                  spawn = [
                    "notify-send"
                    "Rise and shine, Mr. Freeman"
                  ];
                };
              };
              lid-close = _: {
                content = {
                  spawn = [
                    "noctalia-shell"
                    "ipc"
                    "call"
                    "lockScreen"
                    "lock"
                  ];
                };
              };
            };

            prefer-no-csd = _: { };

            binds = {
              # -- KEYBINDINGS --
              # Terminal and Launcher
              "${MainMod}+Return".spawn-sh = "${terminalExe}";
              "${MainMod}+Space".spawn-sh = "${noctaliaExe} ipc call launcher toggle";

              # Screenshot
              "Print".screenshot = _: {
                props = {
                };
              };

              # Session Menu
              "Home" = _: {
                content = {
                  spawn = [
                    "noctalia-shell"
                    "ipc"
                    "call"
                    "sessionMenu"
                    "toggle"
                  ];
                };
              };

              # Window Management
              "${MainMod}+Q".close-window = _: { };
              "${MainMod}+F".maximize-column = _: { };
              "${MainMod}+G".fullscreen-window = _: { };
              "${MainMod}+Shift+F".toggle-window-floating = _: { };
              "${MainMod}+V".center-column = _: { };

              # Navigation
              "${MainMod}+H".focus-column-or-monitor-left = _: { };
              "${MainMod}+J".focus-window-or-workspace-down = _: { };
              "${MainMod}+K".focus-window-or-workspace-up = _: { };
              "${MainMod}+L".focus-column-or-monitor-right = _: { };

              "${MainMod}+Left".focus-column-left = _: { };
              "${MainMod}+Right".focus-column-right = _: { };
              "${MainMod}+Up".focus-window-or-workspace-up = _: { };
              "${MainMod}+Down".focus-window-or-workspace-down = _: { };

              # Moving Windows

              "${MainMod}+Shift+H".move-column-left-or-to-monitor-left = _: { };
              "${MainMod}+Shift+J".move-window-down-or-to-workspace-down = _: { };
              "${MainMod}+Shift+K".move-window-up-or-to-workspace-up = _: { };
              "${MainMod}+Shift+L".move-column-right-or-to-monitor-right = _: { };

              "${MainMod}+Shift+Left".move-column-to-monitor-left = _: { };
              "${MainMod}+Shift+Down".move-column-to-monitor-down = _: { };
              "${MainMod}+Shift+Up".move-column-to-monitor-up = _: { };
              "${MainMod}+Shift+Right".move-column-to-monitor-right = _: { };

              "${MainMod}+Home".focus-column-first = _: { };
              "${MainMod}+End".focus-column-last = _: { };
              "${MainMod}+Ctrl+Home".move-column-to-first = _: { };
              "${MainMod}+Ctrl+End".move-column-to-last = _: { };

              "${MainMod}+1".focus-workspace = "w1";
              "${MainMod}+2".focus-workspace = "w2";
              "${MainMod}+3".focus-workspace = "w3";
              "${MainMod}+4".focus-workspace = "w4";
              "${MainMod}+5".focus-workspace = "w5";
              "${MainMod}+6".focus-workspace = "w6";
              "${MainMod}+7".focus-workspace = "w7";
              "${MainMod}+8".focus-workspace = "w8";
              "${MainMod}+9".focus-workspace = "w9";

              "${MainMod}+Shift+1".move-column-to-workspace = "w1";
              "${MainMod}+Shift+2".move-column-to-workspace = "w2";
              "${MainMod}+Shift+3".move-column-to-workspace = "w3";
              "${MainMod}+Shift+4".move-column-to-workspace = "w4";
              "${MainMod}+Shift+5".move-column-to-workspace = "w5";
              "${MainMod}+Shift+6".move-column-to-workspace = "w6";
              "${MainMod}+Shift+7".move-column-to-workspace = "w7";
              "${MainMod}+Shift+8".move-column-to-workspace = "w8";
              "${MainMod}+Shift+9".move-column-to-workspace = "w9";

              # "${MainMod}+1".focus-workspace = 1;
              # "${MainMod}+2".focus-workspace = 2;
              # "${MainMod}+3".focus-workspace = 3;
              # "${MainMod}+4".focus-workspace = 4;
              # "${MainMod}+5".focus-workspace = 5;
              # "${MainMod}+6".focus-workspace = 6;
              # "${MainMod}+7".focus-workspace = 7;
              # "${MainMod}+8".focus-workspace = 8;
              # "${MainMod}+9".focus-workspace = 9;
              # "${MainMod}+Shift+1".move-column-to-workspace = 1;
              # "${MainMod}+Shift+2".move-column-to-workspace = 2;
              # "${MainMod}+Shift+3".move-column-to-workspace = 3;
              # "${MainMod}+Shift+4".move-column-to-workspace = 4;
              # "${MainMod}+Shift+5".move-column-to-workspace = 5;
              # "${MainMod}+Shift+6".move-column-to-workspace = 6;
              # "${MainMod}+Shift+7".move-column-to-workspace = 7;
              # "${MainMod}+Shift+8".move-column-to-workspace = 8;
              # "${MainMod}+Shift+9".move-column-to-workspace = 9;

              # The following binds move the focused window in and out of a column.
              # If the window is alone, they will consume it into the nearby column to the side.
              # If the window is already in a column, they will expel it out.
              "${MainMod}+BracketLeft".consume-or-expel-window-left = _: { };
              "${MainMod}+BracketRight".consume-or-expel-window-right = _: { };

              # --- Media Keys (The Requested Rewrite) ---
              "XF86AudioRaiseVolume" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ --limit 1.0";
                };
              };
              "XF86AudioLowerVolume" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
                };
              };
              "XF86AudioMute" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn = [
                    "wpctl"
                    "set-mute"
                    "@DEFAULT_AUDIO_SINK@"
                    "toggle"
                  ];
                };
              };
              "XF86AudioMicMute" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn = [
                    "wpctl"
                    "set-mute"
                    "@DEFAULT_AUDIO_SOURCE@"
                    "toggle"
                  ];
                };
              };

              "XF86MonBrightnessUp" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn = [
                    "${noctaliaExe}"
                    "ipc"
                    "call"
                    "brightness"
                    "increase"
                  ];
                };
              };
              "XF86MonBrightnessDown" = _: {
                props = {
                  allow-when-locked = true;
                };
                content = {
                  spawn = [
                    "${noctaliaExe}"
                    "ipc"
                    "call"
                    "brightness"
                    "decrease"
                  ];
                };
              };

              # "XF86MonBrightnessUp" = _: {
              #   props = {
              #     allow-when-locked = true;
              #   };
              #   content = {
              #     spawn = [
              #       "brightnessctl"
              #       "set"
              #       "20%+"
              #     ];
              #   };
              # };
              # "XF86MonBrightnessDown" = _: {
              #   props = {
              #     allow-when-locked = true;
              #   };
              #   content = {
              #     spawn = [
              #       "brightnessctl"
              #       "set"
              #       "20%-"
              #     ];
              #   };
              # };

              "${MainMod}+O" = _: {
                props = {
                  repeat = false;
                };
                content = {
                  toggle-overview = _: { };
                };
              };

              # "${MainMod}+d".spawn-sh = wlrWhichKeyExe [
              #   {
              #     key = "b";
              #     desc = "kitty test";
              #     cmd = "${terminalExe}";
              #   }
              # ];

              # "${MainMod}+d".spawn-sh = self.mkWhichKeyExe config.pkgs [
              #   {
              #     key = "b";
              #     desc = "Bluetooth";
              #     cmd = "${noctaliaExe} ipc call bluetooth togglePanel";
              #   }
              # ];

              "${MainMod}+W".spawn-sh = self.mkWhichKeyExe pkgs [
                {
                  key = "b";
                  desc = "Browsing";
                  cmd = "niri msg action focus-workspace \"browser\"";
                }
                {
                  key = "o";
                  desc = "Options";
                  cmd = "niri msg action focus-workspace \"options\"";
                }
                {
                  key = "m";
                  desc = "Methods";
                  cmd = "niri msg action focus-workspace \"methods\"";
                }
                {
                  key = "c";
                  desc = "Communication";
                  cmd = "niri msg action focus-workspace \"communication\"";
                }
                {
                  key = "n";
                  desc = "Notes";
                  cmd = "niri msg action focus-workspace \"notes\"";
                }
              ];

              "${MainMod}+C".spawn-sh = self.mkWhichKeyExe pkgs [
                {
                  key = "m";
                  desc = "Noctalia Settings";
                  cmd = "${noctaliaExe} ipc call settings toggle";
                }
                {
                  key = "b";
                  desc = "Bluetooth";
                  cmd = "${noctaliaExe} ipc call bluetooth togglePanel";
                }
                {
                  key = "w";
                  desc = "Wifi";
                  cmd = "${noctaliaExe} ipc call network togglePanel";
                }
                {
                  key = "n";
                  desc = "Toggle DND";
                  cmd = "${noctaliaExe} ipc call notifications toggleDND";
                }
                {
                  key = "p";
                  desc = "Toggle Performance Mode";
                  cmd = "${noctaliaExe} ipc call powerProfile toggleNoctaliaPerformance";
                }
                {
                  key = "s";
                  desc = "Save shell settings";
                  cmd = "${noctaliaExe} ipc call state all > ~/nixdots/modules/features/noctalia.json";
                }

              ];

              "${MainMod}+d".spawn-sh = self.mkWhichKeyExe pkgs [
                {
                  key = "f";
                  desc = "Firefox";
                  cmd = "${lib.getExe pkgs.firefox}";
                }
                {
                  key = "c";
                  desc = "Beeper";
                  cmd = "beeper";
                }
                {
                  key = "d";
                  desc = "Discord";
                  cmd = "vesktop";
                }
                {
                  key = "b";
                  desc = "Bitwarden";
                  cmd = "bitwarden";
                }
                {
                  key = "l";
                  desc = "localsend";
                  cmd = "localsend_app";
                }
              ];
              # "${MainMod}+d".spawn = "${self'.packages.wlr-which-key}";
            };

            workspaces =
              let
                default = { };
              in
              {
                "options" = default;
                "methods" = default;
                "browser" = default;
                "notes" = default;
                "communication" = default;
                "w1" = default;
                "w2" = default;
                "w3" = default;
                "w4" = default;
                "w5" = default;
                # "w6" = default;
                # "w7" = default;
                # "w8" = default;
                # "w9" = default;
              };

            # add the below once niri updates to 26.04!
            # niri has updated to 26.04
            extraConfig = ''
              include optional=true "~/.config/niri/noctalia.kdl"
            '';
          };
      };
    };
}
