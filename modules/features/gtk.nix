{ inputs, ... }:
{
  flake.nixosModules.gtk =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nwg-look
        adw-gtk3
        kdePackages.qt6ct
      ];

      qt = {
        enable = true;
        # for some stupid weird reason its qt5ct to apply qt6ct?
        # also set in environment.nix (for env-vars)
        platformTheme = "qt5ct";
      };

      # gtk theming for noctalia
      programs.dconf = {
        enable = true;
        profiles.user.databases = [
          {
            settings = {
              "org/gnome/desktop/interface" = {
                color-scheme = "prefer-dark";
                gtk-theme = "adw-gtk3-dark";
              };
            };
          }
        ];
      };
    };
}
