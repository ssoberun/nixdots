{
  flake.nixosModules.linux-kernel = { pkgs, ... }: {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
