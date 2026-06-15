{ self, ... }:
{
  flake.nixosModules.typst =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        typst
        typstyle
      ];
    };
}
