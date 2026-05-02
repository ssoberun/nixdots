{
  flake.nixosModules.opencloud = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # opencloud
      opencloud-desktop
    ];
  };
}
