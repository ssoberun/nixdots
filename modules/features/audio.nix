{ inputs, ... }:
{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.pavucontrol
      ];
    };

  flake.nixosModules.audio-common = { config, pkgs, ... }: {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # automatically switches audio to active audio source
      wireplumber.enable = true;
    };
  };
}
