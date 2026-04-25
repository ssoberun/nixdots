{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs; # THIS PART IS VERY IMPORTAINT, I FORGOT IT IN THE VIDEO!!!
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.noctalia-shell)
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

	input = {
	  keyboard = {
	    xkb = {
	      layout = "us";
	    };
	  };
	  mouse = {
	    accel-profile = "flat";
	  };
	};

        layout.gaps = 5;

        binds = {
          "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+Space".spawn-sh = "${lib.getExe self'.packages.noctalia-shell} ipc call launcher toggle";
          "Mod+C".close-window = null;
          "Mod+F".maximize-column = null;
          "Mod+G".fullscreen-window = null;
          "Mod+Shift+F".toggle-window-floating = null;
          "Mod+V".center-column = null;

          "Mod+H".focus-column-left = null;
          "Mod+L".focus-column-right = null;
          "Mod+K".focus-window-up = null;
          "Mod+J".focus-window-down = null;

          "Mod+Left".focus-column-left = null;
          "Mod+Right".focus-column-right = null;
          "Mod+Up".focus-window-up = null;
          "Mod+Down".focus-window-down = null;

          "Mod+Shift+H".move-column-left = null;
          "Mod+Shift+L".move-column-right = null;
          "Mod+Shift+K".move-window-up = null;
          "Mod+Shift+J".move-window-down = null;
        };
      };
    };
  };
}
