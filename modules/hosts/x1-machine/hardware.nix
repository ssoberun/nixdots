{self, inputs, ...}: {
	flake.nixosModules.x1-machine-hardware = {config, lib, pkgs, modulesPath, ...}: {
		  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/d976dde6-3a99-4d2b-8242-1d18811edaba";
      fsType = "ext4";
    };

 	 fileSystems."/boot" = { 
	device = "/dev/disk/by-uuid/0654-6472";
  	   fsType = "vfat";
 	   options = [ "fmask=0077" "dmask=0077" ];
	    };

	  swapDevices = [ ];

		  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
 		 hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

	};
}
