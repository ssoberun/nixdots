{ inputs, ... }: {
  flake.nixosModules.systemd-boot = { pkgs, ... }: {
    boot.boot.loader.systemd-boot.enable = true;
    boot = {
      plymouth = {
        theme = "evangelion-ui";
        themePackages = [
          inputs.evangelion-ui.packages.${pkgs.stdenv.hostPlatform.system}.evangelion-ui
        ];
        enable = true;
      };

      loader.efi.canTouchEfiVariables = true;

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
