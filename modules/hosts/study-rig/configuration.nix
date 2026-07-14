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
        self.nixosModules.systemd-boot
        self.nixosModules.BORE-cachy-kernel

        # unwrapped, modularised
        self.nixosModules.desktop
        self.nixosModules.opencloud
        self.nixosModules.audio-common

        # nix settings
        self.nixosModules.nix

        # base
        self.nixosModules.base
        self.nixosModules.core
        self.nixosModules.gaming

        # laptop (move to a diff file?)
        # disabled here for obv reasons
        # self.nixosModules.tlp # tlp conflicts
        ## suspending and hibernate
        # self.nixosModules.suspend-and-hibernate

        # wrapped modules
        self.nixosModules.mySops
        # self.nixosModules.noctalia # this is to let noctalia be accessed via shell
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

        # roblox studio test
        vinegar

        # cursor test
        # now put in runtimeInputs of niri.nix, revert if went wrong.
        apple-cursor
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
            "gamemode"
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
      # because i dual boot with windows, have this setting on
      time.hardwareClockInLocalTime = true;
      i18n.defaultLocale = "en_AU.UTF-8";

      # desktop environment
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

      # --- Services ---
      services.printing.enable = true;
      security.rtkit.enable = true;
      system.stateVersion = "25.11";

      # hibernation
      # # Physical offset: The first number under 'physical_offset' from ext 0
      # boot.kernelParams = [
      #   "resume_offset=20072448"
      #   "mem_sleep_default=deep"
      # ];
      # # Resume Device: The UUID of your ext4 'root' partition (nvme0n1p5)
      # boot.resumeDevice = "/dev/disk/by-uuid/6034c26a-575e-4e70-a7c3-cc657cc592a0";
      # powerManagement.enable = true;
      #
      # # Suspend first then hibernate when closing the lid
      # services.logind.settings.Login.LidSwitch = "suspend-then-hibernate";
      # # Hibernate on power button pressed
      # services.logind.settings.Login.PowerKey = "hibernate";
      # services.logind.settings.Login.PowerKeyLongPress = "poweroff";

      swapDevices = [
        {
          device = "/var/lib/swapfile";
          size = 16 * 1024; # 16 gb because im not hibernating
        }
      ];

      # --- Hardware ---

      fileSystems."/mnt/storage" = {
        device = "/dev/disk/by-uuid/06F69E82F69E7223";
        fsType = "ntfs3";
        options = [
          "rw"
          "uid=1000"
          "gid=100"
          "umask=0022"
          "nofail"
        ];
      };

      # the following doesnt work since my C: is corrupted with a dirty bit; see mendawa
      # fileSystems."/mnt/windows-primary" = {
      #   device = "/dev/disk/by-uuid/01DD036613725370";
      #   fsType = "ntsf3";
      #   options = [
      #     "rw"
      #     "uid=1000"
      #     "gid=100"
      #     "umask=0022"
      #     "nofail"
      #   ];
      # };

      # firmware updates and fstirm
      services.fwupd.enable = true;
      services.fstrim.enable = true;

      # AMD CPUs
      boot.initrd.kernelModules = [ "amdgpu" ];
      # Nvidia Driver
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        modesetting.enable = true;
        open = false; # set true for gpus that support it; recommended
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.production;
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      # fix black sceen
      systemd.services."systemd-suspend" = {
        serviceConfig = {
          Environment = ''"SYSTEMD_SLEEP_FREEZE_USER_SESSIONS=false"'';
        };
      };
      boot.extraModprobeConfig = ''
        options nvidia_modeset vblank_sem_control=0 nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp
      '';
      boot.kernelModules = [
        "nvidia_uvm"
        "nvidia_modeset"
        "nvidia_drm"
        "nvidia"
      ];
      boot.kernelParams = [ "nvidia-drm.modeset=1" ];
    };
}
