{
  flake.nixosModules.mpv = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.mpv
    ];
  };
}
