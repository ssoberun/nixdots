{ self, inputs, ... }: {
  flake.nixosModules.x1-machine-configuration = { pkgs, lib, config, self', ... }: {
    
    imports = [
      # Hardware and Inputs
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
      self.nixosModules.x1-machine-hardware


      # unwrapped, modularised
      self.nixosModules.desktop
      self.nixosModules.opencloud

      # base
      self.nixosModules.base
      self.nixosModules.core
      self.nixosModules.gaming
      
      # laptop (move to a diff file?)
      self.nixosModules.tlp # tlp conflicts
      ## suspending and hibernate
      self.nixosModules.suspend-and-hibernate

      # wrapped modules
      self.nixosModules.mySops
      self.nixosModules.noctalia # this is to let noctalia be accessed via shell 
    ];
    
    # --- Environment & Packages ---
    environment.systemPackages = with pkgs; [
      vim
      wget
      age

      kitty # by adding kitty here, noctalia shell seems to recognize the package rathe rthan the wrpaped one we made.

      firefox
      bitwarden-desktop

      # cursor test
      apple-cursor
    ];
    
    # --- User Configuration ---
    preferences.user.name = "sam";
    users.users = {
      # primary user
      "${config.preferences.user.name}" = {
        isNormalUser = true;
        description = "${config.preferences.user.name}, he is the primary user";
        extraGroups = [ "networkmanager" "wheel" "video" ];
	initialPassword = "password";
        shell = self.packages.${pkgs.stdenv.hostPlatform.system}.shell-environment;
      };
      # shell = "${self.packages.${pkgs.stdenv.hostPlatform.system}.shell-environment}/bin/fish";
      # shell = self.packages.${pkgs.stdenv.hostPlatform.system}.fish;
    };

    # --- System Core ---
    networking.hostName = "x1-machine"; 
    networking.networkmanager.enable = true;
    time.timeZone = "Australia/Sydney";
    i18n.defaultLocale = "en_AU.UTF-8";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;

    # --- Boot & Kernel ---
    boot.plymouth = { 
      enable = true;
    };
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # --- Feature Toggles ---
    # Assuming you followed the modular sops.nix we discussed:

    # --- Desktop Environment ---
    # Note: You have Niri imported, but GDM/GNOME are enabled here.
    # Keep both if you want a fallback, otherwise disable GNOME to stay minimal.
    services.displayManager.ly = {
      enable = true;
      settings = {
        animation = "doom";
      };
    };
    services.xserver = {
      enable = true;
      
      xkb = {
        layout = "au";
        variant = "";
      };
    };

    # --- Sound & Services ---
    services.printing.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    system.stateVersion = "25.11"; 

    # hibernation
    # Physical offset: The first number under 'physical_offset' from ext 0
    boot.kernelParams = [ "resume_offset=20072448" "mem_sleep_default=deep" ];
    # Resume Device: The UUID of your ext4 'root' partition (nvme0n1p5)
    boot.resumeDevice = "/dev/disk/by-uuid/d976dde6-3a99-4d2b-8242-1d18811edaba";   
    powerManagement.enable = true;

    # Suspend first then hibernate when closing the lid
    services.logind.settings.Login.LidSwitch = "suspend-then-hibernate";
    # Hibernate on power button pressed
    services.logind.settings.Login.PowerKey = "hibernate";
    services.logind.settings.Login.PowerKeyLongPress = "poweroff";

    swapDevices = [
     {
       device = "/var/lib/swapfile";
       size = 16 * 1024;
     }
    ];
    
    # graphics (intel)
    hardware = {
      # opengl = {
      #   enable = true;
      #   driSupport = true;
      #   driSupport32Bit = true;
      # };
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver
          vpl-gpu-rt
	        libvdpau-va-gl
        ];
      };
    };

    environment.variables = {
      LIBVA_DRIVER_NAME = "iHD";
    };

    # firmware updates and fstirm
    services.fwupd.enable = true;
    services.fstrim.enable = true;

    # ssh 
    # no home manager, thus, system wide ssh...
    programs.ssh = {
      # conflicts with GNOME ssh
      # startAgent = true;

      # Raw configuration for /etc/ssh/ssh_config
      extraConfig = ''
        Host github.com
          HostName github.com
          User git
          IdentityFile ${config.sops.secrets.github_ssh_key.path}
          IdentitiesOnly yes
      '';
    };
  };
}
