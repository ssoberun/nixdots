{ self, inputs, ... }: {
  flake.nixosModules.neovim = {pkgs, lib, ...}: {
    programs.neovim = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
    };
  };
  perSystem = { pkgs, system, ... }: {
    packages.neovim = (inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
    #   modules = [
    #     {
    #       config.vim = {
    #         # Basic Setup
    #         viAlias = true;
    #         vimAlias = true;
    #         useSystemClipboard = true;
    #
    #         # Enable the things you need
    #         lsp.enable = true;
    #         telescope.enable = true;
    #         treesitter.enable = true;
    #
    #         # Since you're doing Year 11 Math/Physics
    #         languages.nix.enable = true;
    #         languages.markdown.enable = true; 
    #
    #         # Visuals
    #         theme = {
    #           enable = true;
    #           name = "catppuccin";
    #           style = "mocha";
    #         };
    #       };
    #     }
    #   ];
    # }).neovim; # .neovim gives you the actual wrapped package
   });
  };
}
