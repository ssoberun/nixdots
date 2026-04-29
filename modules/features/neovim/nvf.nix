{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.nvf-config = {
    config.vim = {
      theme = {
        enable = true;
        name = "catpuccin";
        style = "dark";
      };
      options = {
        tabstop = 2;      # Number of spaces a <Tab> counts for
        shiftwidth = 2;   # Number of spaces for auto-indent
        expandtab = true; # Convert tabs to spaces (highly recommended for Nix)
        smartindent = true;
      };

      statusline.lualine.enable = true;
      telescope.enable = true;
      autocomplete.nvim-cmp.enable = true;

      languages = {
        enableLSP = true;
        enableTreesitter = true;

        nix.enable = true;
        rust.enable = true;
        ts.enable = true;
      };
    };
  };

  flake.nixosModules.nvf-keybinds = {
    config = {
      
    };
  };

  perSystem = {
    self',
    pkgs,
    ...
  }: {
    packages.neovim-nvf =
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [
            self.nixosModules.nvf-config
        ];
      }).neovim;
  };
}
