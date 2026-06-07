{
  self,
  inputs,
  lib,
  ...
}:
{
  # flake.nixosModules.fish = {pkgs, ...}: {
  #   programs.fish = {
  #     enable = true;
  #     package = self.packages.${pkgs.stdenv.hostPlatform.system}.fish;
  #   };
  # };
  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    let
      fishConf = pkgs.writeText "fishy-fishy" /* bash */ ''
        function y
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          command yazi $argv --cwd-file="$tmp"
          if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
            builtin cd -- "$cwd"
          end
          rm -f -- "$tmp"
        end

        function fish_prompt
            string join "" -- (set_color red) "[" (set_color yellow) $USER (set_color green) "@" (set_color blue) $hostname (set_color magenta) " " $(prompt_pwd) (set_color red) ']' (set_color normal) "\$ "

        end

        set fish_greeting
        fish_vi_key_bindings
        alias ls eza

        ${lib.getExe pkgs.zoxide} init fish | source

        function lf --wraps="lf" --description="lf - Terminal file manager (changing directory on exit)"
            cd "$(command lf -print-last-dir $argv)"
        end

        if type -q direnv
            direnv hook fish | source
        end
      '';
    in
    {
      packages.fish = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.fish;
        runtimeInputs = [
          pkgs.zoxide
        ];
        flags = {
          "-C" = "source ${fishConf}";
        };
      };
    };
}
# {self, inputs, ...}: {
#   flake.nixosModules.fish =
#     {
#       config,
#       pkgs,
#       ...
#     }: {
#       programs = {
#         fish = {
#           enable = true;
#           # seems like shell abbreviations take precedence over aliases
#           shellAbbrs = config.environment.shellAliases // {
#             ehistory = ''nvim "/home/sam/fish/fish_history"'';
#           };
#           shellInit =
#             /* fish */ ''
#               # shut up welcome message
#               function fish_greeting
#
# 	      end
#
#               # use vi key bindings with hybrid emacs keybindings
#               # function fish_user_key_bindings
#               #     fish_default_key_bindings -M insert
#               #     fish_vi_key_bindings --no-erase insert
#               # end
#
#               # setup vi mode
#               fish_vi_key_bindings
# a
#             ''
#             # sponge options
#             + ''
#               # set options for plugins
#               set sponge_regex_patterns 'password|passwd|^kill'
#
#               # bind --mode default \t complete-and-search
#             '';
#         };
#       };
#
#       # fish plugins
#       environment = {
#         # install fish completions for fish
#         # https://github.com/nix-community/home-manager/pull/2408
#         pathsToLink = [ "/share/fish" ];
#
#         systemPackages = [
#           # do not add failed commands to history
#           pkgs.fishPlugins.sponge
#           # fish-completion-sync
#         ];
#       };
#     };
# }
