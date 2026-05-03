{
  flake.nixosModules.discord = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.mpv
    ];
  };
}
