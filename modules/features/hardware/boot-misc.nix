{ inputs, ... }: {
  flake.nixosModules.boot-misc = { lib, pkgs, ... }: {
    boot = {
      plymouth = {
        theme = "evangelion-ui";
        themePackages = [
          inputs.evangelion-ui.packages.${pkgs.stdenv.hostPlatform.system}.evangelion-ui
        ];
        enable = true;
      };

      initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
      ];

      loader = {
        efi.canTouchEfiVariables = lib.mkDefault true;
        timeout = lib.mkDefault null;
      };
    };
  };
}
