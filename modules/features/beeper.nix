{
  flake.nixosModules.beeper =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.beeper
      ];
    };
}
