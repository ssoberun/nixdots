{ self, inputs, ... }:
{
  flake.nixosModules.study-rig-configuration =
    {
      pkgs,
      lib,
      config,
      self',
      ...
    }:
    {

      imports = [
        # Hardware and Inputs
        self.nixosModules.study-rig-hardware

        # unwrapped, modularised
        self.nixosModules.desktop
        self.nixosModules.opencloud

        # nix settings
        self.nixosModules.nix

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
        # self.nixosModules.ollama
      ];

      # --- Environment & Packages ---
      environment.systemPackages = with pkgs; [
        vim
        wget
        age

        sioyek # same with sioyek

        firefox
        bitwarden-desktop
        spotify

        godot_4

        claude-code

        # cursor test
        # now put in runtimeInputs of niri.nix, revert if went wrong.
        apple-cursor
        antigravity
        geoclue2
      ];

      # location services
      # Set Geoclue as the default location provider
      location.provider = "geoclue2";
      # Enable Geoclue
      services.geoclue2 = {
        enable = true;
        # if using beaconDB
        # geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
      };

      # --- User Configuration ---
      preferences.user.name = "sam";
      users.users = {
        # primary user
        "${config.preferences.user.name}" = {
          isNormalUser = true;
          description = "${config.preferences.user.name}, he is the primary user";
          extraGroups = [
            "networkmanager"
            "wheel"
            "video"
          ];
          initialPassword = "password";
          hashedPasswordFile = config.sops.secrets."users/sam-password".path;
          shell = self.packages.${pkgs.stdenv.hostPlatform.system}.shell-environment;
        };
        # shell = "${self.packages.${pkgs.stdenv.hostPlatform.system}.shell-environment}/bin/fish";
        # shell = self.packages.${pkgs.stdenv.hostPlatform.system}.fish;
      };

      # --- System Core ---
      networking.hostName = "study-rig";
      networking.networkmanager.enable = true;
      time.timeZone = "Australia/Sydney";
      # because i dual boot with windows
      time.hardwareClockInLocalTime = true;
      i18n.defaultLocale = "en_AU.UTF-8";

      # --- Boot & Kernel ---
      boot.plymouth = {
        theme = "evangelion-ui";
        themePackages = [
          inputs.evangelion-ui.packages.${pkgs.stdenv.hostPlatform.system}.evangelion-ui
        ];
        enable = true;
      };
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelPackages = pkgs.linuxPackages_latest;
      boot.initrd.availableKernelModules = [
      	  "nvme" 
  "xhci_pci" 
  "ahci" 
  "usb_storage" 
  "sd_mod" 
      ];

      # CachyOS kernel using https://github.com/xddxdd/nix-cachyos-kernel
      # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
      # nixpkgs.overlays = [
      #   inputs.nix-cachyos-kernel.overlays.default
      # ];
      # nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
      # nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];

      # --- Feature Toggles ---
      # Assuming you followed the modular sops.nix we discussed:

      # --- Desktop Environment ---
      # Note: You have Niri imported, but GDM/GNOME are enabled here.
      # Keep both if you want a fallback, otherwise disable GNOME to stay minimal.
      services.displayManager.ly = {
        enable = true;
        settings = {
          animation = "colormix";
        };
      };
      services.xserver = {
        enable = true;

        xkb = {
          layout = "au";
          variant = "";
        };
      };

      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.waylandFrontend = true;
        fcitx5.addons = with pkgs; [
          qt6Packages.fcitx5-chinese-addons # Provides Pinyin for Simplified Chinese
          fcitx5-gtk # Optional: for GTK app support
        ];
      };

      # autocpufreq testing
      # services.auto-cpufreq = {
      #   enable = true;
      #   settings = {
      #     battery = {
      #       governor = "powersave";
      #       turbo = "never";
      #     };
      #     charger = {
      #       governor = "performance";
      #       turbo = "auto";
      #     };
      #   };
      # };

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
      boot.kernelParams = [
        "resume_offset=20072448"
        "mem_sleep_default=deep"
      ];
      # Resume Device: The UUID of your ext4 'root' partition (nvme0n1p5)
      boot.resumeDevice = "/dev/disk/by-uuid/6034c26a-575e-4e70-a7c3-cc657cc592a0";
      powerManagement.enable = true;

      # Suspend first then hibernate when closing the lid
      services.logind.settings.Login.LidSwitch = "suspend-then-hibernate";
      # Hibernate on power button pressed
      services.logind.settings.Login.PowerKey = "hibernate";
      services.logind.settings.Login.PowerKeyLongPress = "poweroff";

      swapDevices = [
        {
          device = "/var/lib/swapfile";
          size = 16 * 1024; # 16 gb
        }
      ];

      # firmware updates and fstirm
      services.fwupd.enable = true;
      services.fstrim.enable = true;

      services.fprintd = {
        enable = false;
        # tod = {
        #   enable = true;
        #   driver = pkgs.libfprint-2-tod1-vfs0090;
        # };
      };

      # ssh
      # no home manager, thus, system wide ssh...
      # programs.ssh = {
      #   # conflicts with GNOME ssh
      #   # startAgent = true;
      #
      #   # Raw configuration for /etc/ssh/ssh_config
      #   extraConfig = ''
      #     Host github.com
      #       HostName github.com
      #       User git
      #       IdentityFile ${config.sops.secrets.github_ssh_key.path}
      #       IdentitiesOnly yes
      #   '';
      # };
    };
}
