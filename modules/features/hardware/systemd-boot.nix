{ inputs, ... }: {
  flake.nixosModules.systemd-boot = { pkgs, ... }: {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = null;
      };

      initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
      ];

    };

  };
}
