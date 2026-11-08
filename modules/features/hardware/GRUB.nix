{ inputs, ... }: {
  flake.nixosModules.GRUB = { pkgs, ... }: {
    boot = {
      loader.grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
    };
  };
}
