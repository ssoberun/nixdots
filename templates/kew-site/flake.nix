{
  description = "A super simple static site supplier";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    kew-src = {
      url = "github:uint23/kew/master";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
      kew-src,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        kew-pkg = pkgs.buildGoModule {
          pname = "kew";
          version = "0.1.0";
          src = kew-src;

          vendorHash = null;

          nativeBuildInputs = [ pkgs.makeWrapper ];
          buildInputs = [ pkgs.lowdown ];
          postInstall = ''
            wrapProgram $out/bin/kew \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.lowdown ]}
          '';

          meta = with pkgs.lib; {
            description = "Super simple static site supplier inspired by werc";
            homepage = "https://github.com/yourusername/kew";
            license = licenses.mit;
            maintainers = [ ];
            mainProgram = "kew";
          };
        };

        build-site = pkgs.writeShellApplication {
          name = "build-kew-site";
          runtimeInputs = [
            kew-pkg
            pkgs.go
            pkgs.lowdown
          ];
          text = ''
            set -e

            echo "Building kew site"
            ${pkgs.lib.getExe kew-pkg} ./example/ ./dist/
            echo "Built kew site at ./dist/"
          '';
        };
      in
      {
        packages.default = kew-pkg;

        apps.kew = {
          type = "app";
          program = "${kew-pkg}/bin/kew";
        };

        apps.build-site = {
          type = "app";
          program = "${pkgs.lib.getExe build-site}";
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.go
            pkgs.lowdown
            kew-pkg
            build-site
          ];
        };
      }
    );
}
