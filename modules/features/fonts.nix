{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.fonts =
    { self, pkgs, ... }:
    {
      fonts = {
        fontconfig = {
          defaultFonts = {
            serif = [ "Ubuntu Sans" ];
            sansSerif = [ "Ubuntu Sans" ];
            monospace = [ "JetBrainsMono Nerd Font" ];
          };
        };
        packages =
          with pkgs;
          [
            # english
            ubuntu-sans
            corefonts
            unifont
            iosevka
            _7-segment-font
            # chinese
            noto-fonts-cjk-sans
          ]
          ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
      };
    };
}
