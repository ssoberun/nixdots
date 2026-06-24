{
  self,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  flake.nixosModules.fonts =
    let
      xanh-mono = pkgs.stdenv.mkDerivation {
        pname = "xanh-mono";
      };
    in

    { self, pkgs, ... }:
    {
      fonts = {
        fontconfig = {
          antialias = true;
          hinting.enable = true;
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
            google-fonts
            # chinese
            noto-fonts-cjk-sans
            lora
            inter
          ]
          ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
      };
    };
}
