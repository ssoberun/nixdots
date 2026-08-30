{
  flake.nixosModules.tlp =
    { ... }:
    {
      services.thermald.enable = true;
      # must be explicitly disabled in order for tlp to run
      services.power-profiles-daemon.enable = false;
      services.tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 70;

          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;

          # Optional helps save long term battery health
          START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
          STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

          # Forces PCIe links (SSD, Graphics, Wi-Fi) to save power on battery
          PCIE_ASPM_ON_BAT = "powersave";

          # Enables Runtime Power Management for PCIe devices on battery
          RUNTIME_PM_ON_BAT = "auto";

          # Fixes the 100% Wi-Fi (iwlwifi) power drain
          WIFI_PWR_ON_BAT = "on";

          # Fixes Intel Audio / Audio Codec background drain
          SOUND_LPM_ON_BAT = "y";

          # Forces USB devices (like Bluetooth) to autosuspend when idle
          USB_AUTOSUSPEND = 1;
        };
      };
    };
}
