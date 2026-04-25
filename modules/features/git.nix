{self, inputs, ...}: {
  flake.nixosModules.git = { pkgs, lib, ... }: {
    programs.git = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myGit;
    };
  };

  perSystem = {pkgs, lib, self', ...}: {
    packages.myGit = let
      name = "ssoberun";
      email = "5744sam@gmail.com";
    in inputs.wrapper-modules.wrappers.git.wrap {
      inherit pkgs;
      settings = {
        user = {
	  name = name;
	  email = email;
	};

        init = {
          defaultBranch = "main";
        };
      };
    };
  };
}
