{ self, inputs, ... }: {
  flake.nixosModules.BORE-cachy-kernel =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      boot.kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-latest;
      nixpkgs.overlays = [
        inputs.nix-cachyos-kernel.overlays.default
      ];
      # nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
      # nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
    };
}
