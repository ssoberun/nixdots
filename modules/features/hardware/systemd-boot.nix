{ inputs, ... }: {
  flake.nixosModules.systemd-boot = { pkgs, ... }: {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = null;
      };
    };

  };
}
