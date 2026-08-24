{ self, inputs, ... }: {
  flake.nixosModules.obsidian = { pkgs, ... }: {
    # repace back to 1.13 whjen this drops: https://github.com/RyotaUshio/obsidian-pdf-plus/pull/572
    # done as pdf++ is broken rn
    # nixpkgs.overlays = [
    #   (final: prev: {
    #     obsidian = prev.obsidian.overrideAttrs (old: rec {
    #       version = "1.12.7";
    #       src = prev.fetchurl {
    #         url = "https://github.com{version}/obsidian_${version}_amd64.deb";
    #         hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    #       };
    #     });
    #   })
    # ];

    environment.systemPackages = [
      pkgs.obsidian
    ];
  };
}
