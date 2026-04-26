{ self, inputs, ... }: {
  flake.nixosModules.kitty = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.kitty
    ];

    environment.sessionVariables = {
      TERMINAL = "kitty";
    };
  };

  perSystem = { pkgs, lib, ... }: {
    packages.kitty = inputs.wrapper-modules.wrappers.kitty.wrap {
      inherit pkgs;
      settings = {
        cursor_trail = 3;
        background_blur = 1;
        background_opacity = 0.8;
        scrollback_lines = 2000;
        hide_window_decorations = true;
      };

      extraConfig = ''
        include ~/.config/kitty/themes/noctalia.conf
      '';
    };
  };
}


# { self, inputs, ... }: 
# {
#   flake.nixosModules.kitty = { pkgs, lib, config, ... }: 
#   let 
#     # Define the wrapped kitty package INSIDE the module's scope
#     kitty-wrapped = inputs.wrapper-modules.wrappers.kitty.wrap {
#       inherit pkgs;
#       settings = {
#         cursor_trail = 3;
#         background_blur = 1;
#         background_opacity = 0.8;
#         scrollback_lines = 2000;
# 	hide_window_decorations = true;
#       };
#       extraConfig = ''
# 	include ~/.config/kitty/themes/noctalia.conf
#       '';
#     };
#   in
#   {
#     # Add the wrapped package to the system
#     environment.systemPackages = [ kitty-wrapped ];
#
#     # Set the session variables so Niri/others know to use it
#     environment.sessionVariables = {
#       TERMINAL = "kitty";
#     };
#   };
# }

# { inputs, self, ... }: {
#   # We use 'flake' here to export the module so 'self.nixosModules' can find it
#   flake.nixosModules.kitty = { pkgs, lib, self', ... }: {
#     # systemPackages MUST be a list [ ], not a set { }
#     environment.systemPackages = [
#       self'.packages.kitty
#     ];
#
#     environment.sessionVariables = {
#       TERMINAL = "kitty";
#     };
#   };
#
#   perSystem = { pkgs, lib, self', ... }: {
#     packages.kitty = inputs.wrapper-modules.wrappers.kitty.wrap {
#       inherit pkgs;
#       settings = {
#         cursor_trail = 3;
#         background_blur = 1;
#         background_opacity = 0.8;
#         scrollback_lines = 2000;
#       };
#     };
#   };
# }
