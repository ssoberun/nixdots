{self, inputs, ...}: {
  flake.nixosModules.fish =
    {
      config,
      pkgs,
      ...
    }: {
      programs = {
        fish = {
          enable = true;
          # seems like shell abbreviations take precedence over aliases
          shellAbbrs = config.environment.shellAliases // {
            ehistory = ''nvim "/home/sam/fish/fish_history"'';
          };
          shellInit =
            /* fish */ ''
              # shut up welcome message
              function fish_greeting

	      end

              # use vi key bindings with hybrid emacs keybindings
              # function fish_user_key_bindings
              #     fish_default_key_bindings -M insert
              #     fish_vi_key_bindings --no-erase insert
              # end

              # setup vi mode
              fish_vi_key_bindings
a
              # setup fish-completion-sync
              # source ${fish-completion-sync}/init.fish
            ''
            # sponge options
            + ''
              # set options for plugins
              set sponge_regex_patterns 'password|passwd|^kill'

              # bind --mode default \t complete-and-search
            '';
        };
      };

      # fish plugins
      environment = {
        # install fish completions for fish
        # https://github.com/nix-community/home-manager/pull/2408
        pathsToLink = [ "/share/fish" ];

        systemPackages = [
          # do not add failed commands to history
          pkgs.fishPlugins.sponge
          # fish-completion-sync
        ];
      };
    };
}
