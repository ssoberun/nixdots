{
  # shamelessly stolen from https://github.com/iynaix/dotfiles/blob/main/modules/shell/direnv.nix
  flake.nixosModules.base =
    { pkgs, ... }:
    let
      mkdirenv = pkgs.writeShellApplication {
        name = "mkdirenv";
        text =
          # sh
          ''
            nix flake init --template github:ssoberun/nixdots#"$1"
          '';

      };
      redirenv = pkgs.writeShellApplication {
        name = "redirenv";
        text =
          # sh
          ''
            rm -r .direnv .devenv
          '';
      };
    in
    {
      programs.direnv = {
        enable = true;
        silent = false;
        nix-direnv.enable = true;
      };

      environment.systemPackages = [
        pkgs.direnv
        mkdirenv
        redirenv
      ];
    };
}
