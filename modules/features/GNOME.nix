{ pkgs, ... }:
{
  flake.nixosModules.GNOME =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      config = {
        services = {
          desktopManager.gnome.enable = true;
        };

        environment.systemPackages = with pkgs; [
          gnomeExtensions.battery-monitor
        ];

        programs.dconf.profiles.user.databases = [
          {
            settings = {
              "org/gnome/shell" = {
                disable-user-extensions = false;

                enabled-extensions = [
                  "battery-monitor@vjay.me"
                ];
              };
            };
          }
        ];

        # Optional: Clean up GNOME bloat
        environment.gnome.excludePackages = with pkgs; [
          gnome-tour
          geary
          epiphany # web browser
        ];
      };
    };
}
