{
  inputs,
  self,
  lib,
  ...
}:
{
  flake.nixosModules.base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      terminalExe = lib.getExe self.packages.${system}.terminal;
      terminal-desktop-entry = pkgs.makeDesktopItem {
        name = "wrapped-terminal";
        desktopName = "Terminal (wrapped)";
        icon = "kitty";
        genericName = "Terminal Emulator";
        exec = "${terminalExe} %u";
        categories = [
          "System"
          "TerminalEmulator"
        ];
        extraConfig = {
          # this package can be run by terminal apps
          "X-Geany-Terminal" = "true";
        };
      };
    in
    {
      # makes the wrapped terminal a desktop entry
      environment.systemPackages = [
        terminal-desktop-entry
      ];
      # terminal executables go to this wrapped terminal instead of Console
      xdg.terminal-exec = {
        enable = true;
        settings = {
          default = [ "wrapped-terminal.desktop" ];
        };
      };
    };

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
          # pkgs.zoxide
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
          pkgs.tree
          pkgs.nvitop

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
          self'.packages.zoxide

          # testing
          self'.packages.foot
        ];
        env = {
          EDITOR = lib.getExe self'.packages.neovim-nvf;
          NIXOS_ZONE_WL = "1";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          QT_QPLA_PLATFORMTHEME = "qt6ct";
          GIT_BINARY_PATH = lib.getExe self'.packages.git;
        };
      };
    };
}
