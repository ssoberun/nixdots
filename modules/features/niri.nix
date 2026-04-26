{ self, inputs, ... }: {
  flake.nixosModules.niri = { self', pkgs, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
      # package = self'.packages.niri;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = let
        noctaliaExe = lib.getExe self'.packages.noctalia-shell;
      in  {
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
          variable-refresh-rate = _: {};
        };

        layout.gaps = 5;

        binds = {
          # Terminal and Launcher
          "Mod+Return".spawn-sh = "$TERMINAL"; 
          "Mod+Space".spawn-sh = "${noctaliaExe} ipc call launcher toggle";

          
          # Window Management
          "Mod+C".close-window = _: {};
          "Mod+F".maximize-column = _: {};
          "Mod+G".fullscreen-window = _: {};
          "Mod+Shift+F".toggle-window-floating = _:{};
          "Mod+V".center-column = _: {};

          # Navigation
          "Mod+H".focus-column-left = _: {};
          "Mod+L".focus-column-right = _: {};
          "Mod+K".focus-window-or-workspace-up = _: {};
          "Mod+J".focus-window-or-workspace-down = _: {};

          "Mod+Left".focus-column-left = _: {};
          "Mod+Right".focus-column-right = _: {};
          "Mod+Up".focus-window-or-workspace-up = _: {};
          "Mod+Down".focus-window-or-workspace-down = _: {};

          # Moving Windows
	  
          "Mod+Shift+H".move-column-left-or-to-monitor-left = _: { };
          "Mod+Shift+J".move-window-down-or-to-workspace-down = _: { };
          "Mod+Shift+K".move-window-up-or-to-workspace-up = _: { };
          "Mod+Shift+L".move-column-right-or-to-monitor-right = _: { };

          "Mod+Home".focus-column-first = _: {};
          "Mod+End".focus-column-last = _: {};
          "Mod+Ctrl+Home".move-column-to-first = _: {};
          "Mod+Ctrl+End".move-column-to-last = _: {};

          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+7".focus-workspace = 7;
          "Mod+8".focus-workspace = 8;
          "Mod+9".focus-workspace = 9;
          "Mod+Ctrl+1".move-column-to-workspace = 1;
          "Mod+Ctrl+2".move-column-to-workspace = 2;
          "Mod+Ctrl+3".move-column-to-workspace = 3;
          "Mod+Ctrl+4".move-column-to-workspace = 4;
          "Mod+Ctrl+5".move-column-to-workspace = 5;
          "Mod+Ctrl+6".move-column-to-workspace = 6;
          "Mod+Ctrl+7".move-column-to-workspace = 7;
          "Mod+Ctrl+8".move-column-to-workspace = 8;
          "Mod+Ctrl+9".move-column-to-workspace = 9;

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

          "Mod+O" = _: {
            props = {
              repeat = false;
            };
            content = {
              toggle-overview = _: {};
            };
          };
	};

	# add the below once niri updates to 26.04!
        # extraConfig = ''
        #   include optional=true "~/.config/niri/noctalia.kdl"
        # '';
      };
    };
  };
}
