{self, inputs, ...}: {
  flake.homeConfigurations."${config.preferences.user.name}" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [
      self.homeModules."${config.preferences.user.name}Module"
      {
        home.username = "${config.preferences.user.name}";
	home.homeDirectory = "/home/${config.preferences.user.name}"
      }
    ];
  };

  flake.homeModules."${config.preferences.user.name}Module" = { pkgs, ... }: {
    programs.bash.enable = true;
    programs.bash.shellAliases.ll = "ls -l";

    home.packages = [ pkgs.hello ];
    home.stateVersion = "25.11";
  }
}
