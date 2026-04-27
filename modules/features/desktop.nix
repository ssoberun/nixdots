{self, ...}: {
 flake.nixosModules.desktop = {pkgs, ...}: {
   imports = [
     # wm
     self.nixosModules.niri
     self.nixosModules.GNOME

     # apps
     self.nixosModules.discord

     # desktop visuals
     self.nixosModules.fonts
   ];
 };
}
