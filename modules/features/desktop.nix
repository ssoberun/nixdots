{ self, ... }:
{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      imports = [
        # wm
        self.nixosModules.niri
        self.nixosModules.GNOME

        # latex
        self.nixosModules.LaTeX
        # apps
        self.nixosModules.discord
        self.nixosModules.beeper
        self.nixosModules.obsidian
        self.nixosModules.mpv

        # desktop visuals
        self.nixosModules.fonts
      ];
    };
}
