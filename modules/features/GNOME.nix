{ ... }: {
  flake.nixosModules.gnome = { lib, config, ... }: {
    config = {
      services.xserver = {
	desktopManager.gnome.enable = true;
      };

      # Optional: Clean up GNOME bloat
      environment.gnome.excludePackages = with pkgs; [
        gnome-tour
        geary
        epiphany # web browser
      ];
    };
  };
}
