{
  inputs,
  self,
  lib,
  ...
}:
{
  perSystem =
    {
      self',
      pkgs,
      ...
    }:
    {
      packages.terminal = inputs.wrapper-modules.wrappers.kitty.wrap {
        inherit pkgs;
        imports = [ self.nixosModules.kitty ];
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
          self'.packages.ns
          pkgs.manix
          pkgs.nix-inspect

          # unwrapped
          pkgs.zoxide
          pkgs.libnotify
          pkgs.file
          pkgs.unzip
          pkgs.zip
          pkgs.p7zip
          pkgs.wget
          pkgs.killall
          pkgs.sshfs
          pkgs.fzf
          pkgs.ffmpeg-full
          pkgs.lazygit
          pkgs.dust
          pkgs.eza
          pkgs.imv
          pkgs.bat
          pkgs.broot

          # wrapped
          self'.packages.fastfetch
          self'.packages.git
          self'.packages.lf
          self'.packages.yazi
          self'.packages.btop
          self'.packages.neovim-nvf
          self'.packages.zathura
          self'.packages.qalc
          self'.packages.oh-my-posh
          self'.packages.himalaya

          # testing
          self'.packages.foot
        ];
        env = {
          EDITOR = lib.getExe self'.packages.neovim-nvf;
          NIXOS_ZONE_WL = "1";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          QT_QPLA_PLATFORMTHEME = "qt6ct";
        };
      };
    };
}
