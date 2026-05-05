{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.nvf =
    { pkgs, config, ... }:
    {
      config.vim = {
        # parts of this taken from https://github.com/iynaix/dotfiles/blob/main/modules/shell/neovim/_settings.nix
        # large parts taken frm https://github.com/NotAShelf/nvf/blob/13c4ad4b4bb926c22945e2fb8862769fe51f27f1/configuration.nix

        viAlias = true;
        vimAlias = true;
        debugMode = {
          enable = false;
          level = 16;
          logFile = "/tmp/nvim.log";
        };

        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
        };
        options = {
          tabstop = 2; # Number of spaces a <Tab> counts for
          shiftwidth = 2; # Number of spaces for auto-indent
          expandtab = true; # Convert tabs to spaces (highly recommended for Nix)
          smartindent = true;
        };

        statusline.lualine.enable = true;
        telescope.enable = true;
        autopairs.nvim-autopairs.enable = true;
        comments.comment-nvim.enable = true;
        autocomplete = {
          # nvim-cmp.enable = true;
          blink-cmp.enable = true;
        };

        # git
        git = {
          enable = true;
          neogit.enable = true;
        };
        # enable dashboard?
        # lazy.enable = false;
        dashboard = {
          # startify = {
          #   enable = true;
          #   changeToVCRoot = true;
          # };
          dashboard-nvim.enable = false;
          alpha = {
            enable = true;
          };
        };

        ui = {
          colorizer.enable = true;
          borders.enable = true;
          breadcrumbs = {
            enable = true;
            navbuddy.enable = true;
          };
          smartcolumn = {
            enable = true;
            setupOpts.custom_colorcolumn = {
              # this is a freeform module, it's `buftype = int;` for configuring column position
              nix = "110";
              ruby = "120";
              java = "130";
              go = [
                "90"
                "130"
              ];
            };
          };
        };

        visuals = {
          nvim-scrollbar.enable = true;
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          cinnamon-nvim.enable = true;
          fidget-nvim.enable = true;

          highlight-undo.enable = true;
          blink-indent.enable = true;
          indent-blankline.enable = true;

          # Fun
          # cellular-automaton.enable = false;
        };

        filetree = {
          neo-tree = {
            enable = true;
          };
        };

        treesitter = {
          enable = true;
          addDefaultGrammars = true;
          context.enable = true;
        };

        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        minimap = {
          minimap-vim.enable = true;
          # codewindow.enable = true; # lighter, faster, and uses lua for configuration
        };

        utility = {
          ccc.enable = false;
          vim-wakatime.enable = false;
          diffview-nvim.enable = true;
          yanky-nvim.enable = false;
          qmk-nvim.enable = false; # requires hardware specific options
          icon-picker.enable = true;
          surround.enable = true;
          leetcode-nvim.enable = true;
          multicursors.enable = true;
          smart-splits.enable = true;
          undotree.enable = true;
          nvim-biscuits.enable = true;
          grug-far-nvim.enable = true;

          motion = {
            hop.enable = true;
            leap.enable = true;
            precognition.enable = true;
          };
          images = {
            image-nvim.enable = false;
            img-clip.enable = true;
          };
        };

        languages = {
          enableLSP = true;
          enableFormat = true;
          enableTreesitter = true;

          bash.enable = true;
          lua.enable = true;
          html.enable = true;
          # typescript.enable = true;
          python.enable = true;
          tex = {
            enable = true;
            format = {
              enable = true;
              type = [ "tex-fmt" ];
            };
            lsp = {
              enable = true;
              servers = [ "texlab" ];
            };
          };

          markdown = {
            enable = true;
            extensions.render-markdown-nvim.enable = true;
          };

          nix = {
            enable = true;
            format = {
              enable = true;
              type = [ "nixfmt" ];
            };
            lsp.servers = [
              "nil"
              "nixd"
            ];
          };

          rust = {
            enable = true;
            extensions = {
              crates-nvim.enable = true;
            };
          };
        };
        lsp = {
          enable = true;
          formatOnSave = true;
          # lightbulb.enable = true;
          lspkind.enable = true;
          presets = {
            tailwindcss-language-server.enable = true;
          };
          otter-nvim.enable = true; # provide lsp for embedded languages
          trouble.enable = true;
          lightbulb.enable = true;
          lspsaga.enable = false;
          # lspSignature.enable = !true; # conflicts with blink in maximal
          nvim-docs-view.enable = true;
          presets.harper.enable = true;

          servers = {
            # texlab = {
            #   enable = true;
            #   # im getting an error where vim.lsp.servers.texlab.cmd has already been set somewhere else, though i cannot find this file.
            #   # cmd = [
            #   #   "${lib.getExe pkgs.texlab}"
            #   # ];
            #   filetypes = [ "tex" ];
            # };
          };

          # lspSignature?
          # mappings?
          # servers.nixd = {
          #   settings.options = lib.mkIf (dots != null) {
          #     nixos.expr = "(builtins.getFlake \"${dots}\").nixosConfigurations.${host}.options";
          #   };
          # };
        };

        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };

        # vimtex
        # from https://github.com/KristianSvanholm/nixos/blob/main/modules/home/latex.nix
        globals = {
          tex_flavor = "latex";
          maplocalleader = " ";
          vimtex_compiler_method = "latexmk";
          vimtex_view_method = "sioyek";
          vimtex_compiler_latexmk = {
            callback = 1;
            continuous = 1;
            executable = "latexmk";
            hooks = [ ];
            options = [
              "-verbose"
              "-file-line-error"
              "-synctex=1"
              "-interaction=nonstopmode"
              "-shell-escape"
            ];
          };
        };

        lazy = {
          enable = true;
          plugins.vimtex = {
            # for vimtex shit: https://github.com/NotAShelf/nvf/issues/566
            enabled = true;
            package = pkgs.vimPlugins.vimtex;
            lazy = true; # Changed this
            ft = "tex"; # Added this
            # Added this
          };
        };

        # assistant = {
        #   chatgpt.enable = false;
        #   copilot = {
        #     enable = false;
        #     cmp.enable = isMaximal;
        #   };
        #   codecompanion-nvim.enable = false;
        #   avante-nvim.enable = isMaximal;
        # };
      };
    };

  perSystem =
    {
      self',
      pkgs,
      ...
    }:
    {
      packages.neovim-nvf =
        (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [
            self.nixosModules.nvf
          ];
        }).neovim;
    };
}
