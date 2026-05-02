{
  inputs,
  self,
  lib,
  ...
}: 
{
  perSystem = {
    self',
    pkgs,
    ...
  }: let
    wrappedPkgs = self'.packages;
  in {
    packages.terminal = inputs.wrapper-modules.wrappers.kitty.wrap {
      inherit pkgs;
      imports = [self.nixosModules.kitty];
      # shell is defined in kitty.nix
      settings = {
        shell = lib.getExe self'.packages.shell-environment;
      };
    };
    # packages.terminal = (inputs.wrappers.wrapperModules.kitty.apply {
    #   inherit pkgs;
    #   imports = [self.wrapperModules.kitty];
    #   shell = lib.getExe self'.packages.shell-environment;
    # }).wrapper;

    packages.shell-environment = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = self'.packages.fish;
      runtimeInputs = [
        # nix
        self'.packages.nh
        # unwrapped
        pkgs.zoxide
        pkgs.libnotify

        # wrapped
        self'.packages.git
        self'.packages.lf
        self'.packages.yazi
        self'.packages.btop
        self'.packages.neovim-nvf

        # testing
        self'.packages.foot
      ];
      env = {
        EDITOR = lib.getExe self'.packages.neovim-nvf;
      };
    };
  };
}
