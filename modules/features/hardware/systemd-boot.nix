{ inputs, ... }: {
  flake.nixosModules.systemd-boot = { pkgs, ... }: {
    boot = {
      plymouth = {
        theme = "evangelion-ui";
        themePackages = [
          inputs.evangelion-ui.packages.${pkgs.stdenv.hostPlatform.system}.evangelion-ui
        ];
        enable = true;
      };

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
