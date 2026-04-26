{lib, config, inputs, self, ...}: 
let
  user = "sam";
in {
  flake.config.homeConfigurations."${user}" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [
      self.homeModules."${user}Module"
      {
        home.username = "${user}";
        home.homeDirectory = "/home/${user}";
      }
    ];
  };

  flake.config.homeModules."${user}Module" = { pkgs, lib, ... }: {
    config = {
        # programs.bash.enable = true;
        # programs.bash.shellAliases.ll = "ls -l";
        # home.packages = [ pkgs.hello ];
        # home.stateVersion = "25.11";
    };
  };
}
