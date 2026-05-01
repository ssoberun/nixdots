{self, inputs, ...}: {
  flake.nixosModules.gaming = { pkgs, lib, ... }: {
    programs = {
      steam = {
        enable = true;
        protontricks.enable = true;
      };
      gamemode = {
        enable = true;
      };
      gamescope = {
        enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      protonup-qt
      lutris
      steam-run
      dxvk
      gamescope
      mangohud
      r2modman
      heroic
      er-patcher
      steamtinkerlaunch
      prismlauncher
      lsfg-vk
      lsfg-vk-ui
    ];

  };
}
