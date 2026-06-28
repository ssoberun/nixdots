{
  self,
  lib,
  inputs,
  ...
}:
{
  flake.nixosModules.git =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.git = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.git;
        config.extraConfig.core = {
          sshCommand = "ssh -i ${config.sops.secrets.github_ssh_key.path} -o IdentitiesOnly=yes";
        };
      };
    };

  # from iynaix's dotfiles, on his nvim config
  # this is mostly tesitng
  # flake.nixosModules.core =
  #   { config, pkgs, ... }:
  #   let
  #     git-desktop-entry = pkgs.makeDesktopItem {
  #       name = "git";
  #       desktopName = "Git";
  #       genericName = "Version Control";
  #       icon = "git";
  #       terminal = true;
  #       exec = "${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.git}";
  #     };
  #   in
  #   {
  #     environment = {
  #       systemPackages = [
  #         # (lib.hiPrio git-desktop-entry)
  #       ];
  #     };
  #   };

  perSystem =
    {
      config,
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.git =
        let
          name = "ssoberun";
          email = "5744sam@gmail.com";
        in
        inputs.wrapper-modules.wrappers.git.wrap {
          inherit pkgs;
          runtimePkgs = [
            pkgs.git-lfs
          ];
          settings = {
            user = {
              inherit name email;
            };

            init = {
              defaultBranch = "main";
            };

            core = {
              sshCommand = "ssh -i /run/secrets/github_ssh_key -o IdentitiesOnly=yes";
              # sshCommand = "ssh -i ${config.sops.secrets.github_ssh_key.path} -o IdentitiesOnly=yes";
            };
            settings = {
              "filter \"lfs\"" = {
                clean = "git-lfs clean -- %f";
                smudge = "git-lfs smudge -- %f";
                process = "git-lfs filter-process";
                required = "true"; # Passed as a string atom
              };
            };
          };
        };
    };
}
