{ inputs, ... }:
{
  flake.nixosModules.vpn =
    { config, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        wireguard-tools
        proton-vpn
        proton-vpn-cli
      ];
    };
}
