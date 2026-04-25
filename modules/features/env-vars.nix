{ self, inputs, ... }: {
  flake.nixosModules.env-vars = { pkgs, lib, config, ... }: {
    options.features.env-vars.enable = lib.mkEnableOption "Custom Env Vars";

    config = lib.mkIf config.features.env-vars.enable {
      environment.sessionVariables = {
        # This makes it available to all shells and desktop sessions
        EDITOR = "nvim";
      };
    };
  };
}
