{ inputs, ... }: {
  flake.nixosModules.boot-misc = { pkgs, ... }: {
    boot = {
      plymouth = {
        theme = "evangelion-ui";
        themePackages = [
          inputs.evangelion-ui.packages.${pkgs.stdenv.hostPlatform.system}.evangelion-ui
        ];
        enable = true;
      };
    };
  };
}
