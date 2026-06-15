{ self, ... }:
{
  flake.nixosModules.LaTeX =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        texliveFull
        texlab
        tectonic
        # from https://github.com/KristianSvanholm/nixos/blob/main/modules/home/latex.nix
        inkscape
      ];
    };
}
