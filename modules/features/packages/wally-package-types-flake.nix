{ ... }: {
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    {
      packages.wally-package-types = pkgs.rustPlatform.buildRustPackage rec {
        pname = "wally-package-types";
        version = "1.6.2";

        src = pkgs.fetchFromGitHub {
          owner = "JohnnyMorganz";
          repo = "wally-package-types";
          rev = "v${version}";
          hash = "sha256-ynd5z2pbhGnPTKuJQG4EJL/Zy/X9lTCjSi8Cd6nRSsA=";
        };

        cargoHash = "sha256-LjtnArnv46GzbHnpT3wFNrjCv78stfFc6Kx9RefK+U8=";

        meta = with lib; {
          description = "A small tool which fixes the issue of wally thunks not including exported types, necessary for proper Luau type checking support.";
          homepage = "https://github.com/JohnnyMorganz/wally-package-types";
          license = licenses.mit;
          maintainers = [ ssoberun ];
          mainProgram = "wally-package-types";
        };
      };
    };

}
