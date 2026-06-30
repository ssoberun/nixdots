{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.base =
    { config, pkgs, ... }:
    let
      nvim-nvf = self.packages.${pkgs.stdenv.hostPlatform.system}.neovim-nvf;
      # lowkey this is from iynaix and i dont use nvim-direnv so lol whatever
      nvim-direnv = pkgs.writeShellApplication {
        name = "nvim-direnv";
        runtimeInputs = [ pkgs.direnv ];
        text = /* sh */ ''
          if ! ${lib.getExe pkgs.direnv} exec "$(dirname "$1")" ${lib.getExe nvim-nvf} "$@"; then
              ${lib.getExe nvim-nvf} "$@"
          fi
        '';
      };
      nvim-desktop-entry = pkgs.makeDesktopItem {
        name = "nvim";
        desktopName = "Neovim";
        genericName = "Text Editor";
        icon = "nvim";
        terminal = true;
        # load direnv before opening nvim
        exec = ''${lib.getExe nvim-direnv} "%F"'';
        # exec = "${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.neovim-nvf}";
      };
    in
    {
      environment.systemPackages = [
        nvim-direnv
        (lib.hiPrio nvim-desktop-entry)
      ];

      xdg = {
        mime = {
          defaultApplications = {
            "text/plain" = "nvim.desktop";
            "text/markdown" = "nvim.desktop";
            "text/x-nix" = "nvim.desktop";
            "application/x-shellscript" = "nvim.desktop";
            "application/xml" = "nvim.desktop";
          };
          addedAssociations = {
            "text/csv" = "nvim.desktop";
          };
        };
      };
    };

  flake.nixosModules.nvf =
    { pkgs, config, ... }:
    {
      config.vim = {
        # parts of this taken from https://github.com/iynaix/dotfiles/blob/main/modules/shell/neovim/_settings.nix
        # large parts taken frm https://github.com/NotAShelf/nvf/blob/13c4ad4b4bb926c22945e2fb8862769fe51f27f1/configuration.nix

        # keybinds
        luaConfigPost = /* lua */ ''
          local vimtex_ts_group = vim.api.nvim_create_augroup("VimTexDisableTS", { clear = true })

          -- Listen for LaTeX file types and shut down Tree-sitter for that buffer
          vim.api.nvim_create_autocmd("FileType", {
            pattern = { "tex", "plaintex" },
            group = vimtex_ts_group,
            callback = function(args)
              -- Safely kills the native tree-sitter highlighter instance for this buffer
              vim.treesitter.stop(args.buf)
            end,
          })
        '';
        keymaps =
          let
            mkKeymap = mode: key: action: desc: {
              inherit
                mode
                key
                action
                desc
                ;
            };
            mkKeymapWithOpts =
              mode: key: action: desc: opts:
              (mkKeymap mode key action) // opts;
          in
          [
            (mkKeymap "n" "<leader>e" "<cmd>Neotree toggle<CR>" "Open Neo-tree")
            (mkKeymap "n" "<PageUp>" "<C-U>" "")
            (mkKeymap "n" "<PageDown>" "<C-D>" "")
            (mkKeymap "i" "<PageUp>" "<C-O><C-U>" "")
            (mkKeymap "i" "<PageDown>" "<C-O><C-D>" "")
            # Himalaya Vim
            (mkKeymap "n" "<leader>ml" "<cmd>Himalaya<CR>" "Open Himalaya")

            # Jump backward (Shift+Tab)
            (mkKeymap "i" "<S-Tab>" "<Plug>luasnip-jump-prev" "Jump to previous snippet")
            (mkKeymap "s" "<S-Tab>" "<Plug>luasnip-jump-prev" "Jump to previous snippet")
          ];

        terminal = {
          toggleterm = {
            enable = true;
          };
        };

        viAlias = true;
        vimAlias = true;
        debugMode = {
          enable = false;
          level = 16;
          logFile = "/tmp/nvim.log";
        };

        theme = {
          enable = true;
          # name = "gruber-darker";
          # style = "dark";

          name = "catppuccin";
          style = "mocha";

          # name = "oxocarbon";
          # style = "dark";
          transparent = false;
        };
        options = {
          tabstop = 2; # Number of spaces a <Tab> counts for
          shiftwidth = 2; # Number of spaces for auto-indent
          expandtab = true; # Convert tabs to spaces (highly recommended for Nix)
          smartindent = true;
          conceallevel = 2;
          # concealcursor = "";
        };

        statusline.lualine.enable = true;
        telescope.enable = true;
        autopairs.nvim-autopairs.enable = true;
        comments.comment-nvim.enable = true;
        autocomplete = {
          # nvim-cmp.enable = true;
          blink-cmp = {
            enable = true;
            friendly-snippets.enable = true;
          };
        };

        snippets = {
          # luasnip = {
          #   enable = true;
          #   providers = [
          #     # "vimplugin-luasnip-latex-snippets.nvim"
          #     "friendly-snippets"
          #   ];
          #   setupOpts.enable_autosnippets = true;
          # };
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
          # dashboard-nvim.enable = true;
          alpha = {
            enable = true;
            theme = "theta";
          };
        };

        ui = {
          colorizer.enable = true;
          borders.enable = true;
          breadcrumbs = {
            enable = true;
            navbuddy.enable = true;
          };
          # this adds the little vertical highlight column that shows you not to go too far ig
          smartcolumn = {
            enable = false;
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

          # indent lines (one or the other)
          blink-indent.enable = false;
          indent-blankline.enable = false;

          # Fun
          # cellular-automaton.enable = false;
        };

        filetree = {
          neo-tree = {
            enable = true;
          };
        };

        tabline = {
          nvimBufferline = {
            enable = true;
            # default declaration can be found in https://github.com/NotAShelf/nvf/blob/main/modules/plugins/tabline/nvim-bufferline/nvim-bufferline.nix
            mappings = {
              cycleNext = "<S-l>";
              cyclePrevious = "<S-h>";
            };
            setupOpts.options.diagnostics = "nvim_lsp";
          };
        };

        treesitter = {
          enable = true;
          addDefaultGrammars = true;
          context.enable = true;
          highlight = {
            enable = true;
          };
        };

        binds = {
          whichKey.enable = true;
          # cheatsheet.enable = true;
        };

        minimap = {
          minimap-vim.enable = false;
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
            # hint below lines
            precognition.enable = false;
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
          html.enable = true;
          # typescript.enable = true;
          python.enable = true;

          lua = {
            enable = true;
            extraDiagnostics = {
              enable = true;
              types = [ "selene" ];
            };
            format = {
              enable = true;
              type = [ "stylua" ];
            };
            lsp = {
              enable = true;
              lazydev.enable = false; # enable for nvim plugins
              servers = [ ];
            };
          };

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

          typst = {
            enable = true;
            format = {
              enable = true;
              type = [ "typstyle" ];
            };
            lsp = {
              enable = true;
              servers = [ "tinymist" ];
            };
            extensions = {
              typst-concealer.enable = false;
              typst-preview-nvim = {
                enable = true;
                setupOpts = {
                  open_cmd = "${lib.getExe pkgs.chromium} %s";
                };
              };
            };
          };

          markdown = {
            enable = true;
            extensions.render-markdown-nvim.enable = true;
          };

          go = {
            enable = true;
            format = {
              enable = true;
              type = [ "gofmt" ];
            };
            lsp = {
              enable = true;
              servers = [ "gopls" ];
            };
            extensions = {
              gopher-nvim.enable = false;
            };
          };

          nix = {
            enable = true;
            format = {
              enable = true;
              type = [ "nixfmt" ];
            };
            lsp.servers = [
              # "nil"
              "nixd"
            ];
          };

          rust = {
            enable = true;
            extensions = {
              crates-nvim.enable = true;
            };
          };

          typescript = {
            enable = true;
            format = {
              enable = true;
              type = [ "prettier" ];
            };
            extensions = {
              ts-error-translator.enable = true;
            };
            lsp = {
              enable = true;
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
          lspsaga.enable = false;
          # lspSignature.enable = !true; # conflicts with blink in maximal
          nvim-docs-view.enable = true;
          # grammar is annoying and lints blue
          # presets.harper.enable = true;

          servers = {
            # luau_lsp = {
            #   enable = true;
            #   cmd = [
            #     "${lib.getExe pkgs.luau-lsp}"
            #     "lsp"
            #   ];
            #   filetypes = [
            #     "luau"
            #     "lua"
            #   ];
            #   setupOpts.settings = {
            #     luau-lsp = {
            #       completion = {
            #         imports = {
            #           enabled = true;
            #         };
            #       };
            #       plugin = {
            #         roblox = {
            #           enabled = true; # Enables Roblox global definitions
            #         };
            #       };
            #     };
            #   };
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
          vimtex_syntax_enabled = 1;
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
          vimtex_quickfix_mode = 0;

          vimtex_syntax_conceal = {
            accents = 1;
            ligatures = 1;
            cites = 1;
            fancy = 1;
            greek = 1;
            math_bounds = 1;
            math_delimiters = 1;
            math_fracs = 1;
            math_super_sub = 1;
            math_symbols = 1;
            sections = 1;
            styles = 1;
          };
          vimtex_syntax_conceal_disabled = 0;
          vimtex_syntax_conceal_carg = 1;

          # himalaya mail client globals
          himalaya_executable = "${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.himalaya}";
          himalaya_folder_picker = "telescope";
          himalaya_account_picker = "telescope";
        };

        lazy = {
          enable = true;
          plugins = {
            vimtex = {
              # for vimtex shit: https://github.com/NotAShelf/nvf/issues/566
              enabled = true;
              package = pkgs.vimPlugins.vimtex;
              lazy = true; # Changed this
              ft = "tex"; # Added this
              # Added this
            };
            "himalaya-vim" = {
              enabled = true;
              cmd = [ "Himalaya" ];
              package = pkgs.vimPlugins.himalaya-vim;
              lazy = true;
            };
            "luau-lsp.nvim" = {
              enabled = true;
              package = pkgs.vimPlugins.luau-lsp-nvim;
              ft = [
                "luau"
              ];
              lazy = true;
              after = # lua
                ''
                  require("luau-lsp").setup {
                    platform = {
                      type = "roblox",
                    },
                    types = {
                      roblox_security_level = "PluginSecurity",
                    },
                  }
                '';
            };
            # "luau-lsp.nvim" = {
            #   enabled = true;
            #   package = pkgs.vimPlugins.luau-lsp-nvim;
            #   ft = [
            #     "luau"
            #     "lua"
            #   ];
            #   # setupModule = "luau-lsp";
            #   setupOpts = {
            #     server = {
            #       cmd = [
            #         "${lib.getExe pkgs.luau-lsp}"
            #         "lsp"
            #       ];
            #     };
            #     platform = {
            #       type = "roblox";
            #     };
            #     types = {
            #       roblox_security_level = "PluginSecurity";
            #     };
            #     sourcemap = {
            #       # false as darklua does this in my projects
            #       enabled = false;
            #       autogenerate = false;
            #     };
            #   };
            #   # Use 'after' to force a direct setup fallback if the implicit one misses
            #   after = /* lua */ ''
            #     if not require("lazy.core.config").plugins["luau-lsp.nvim"]._.loaded then
            #       require("luau-lsp").setup({})
            #     end
            #   '';
            # };
            # "luau-lsp.nvim" = {
            #   enabled = true;
            #   package = pkgs.vimPlugins.luau-lsp-nvim;
            #   ft = [
            #     "luau"
            #     "lua"
            #   ];
            #   setupModule = "luau-lsp";
            #   setupOpts = {
            #     server = {
            #       # Ensure the exact executable points into the Nix store with 'lsp' flag mode!
            #       cmd = [
            #         "${lib.getExe pkgs.luau-lsp}"
            #         "lsp"
            #       ];
            #     };
            #     platform = {
            #       type = "roblox";
            #     };
            #     types = {
            #       roblox_security_level = "PluginSecurity";
            #     };
            #     sourcemap = {
            #       enabled = true;
            #       autogenerate = true;
            #     };
            #   };
            # };
          };
        };

        assistant = {
          codecompanion-nvim = {
            enable = true;
            setupOpts = {
              display.chat.intro-message = "the jester looms over the city";
            };
          };
          # chatgpt.enable = false;
          # copilot = {
          #   enable = true;
          #   cmp.enable = true;
          #   # check nvf options to find mappings
          #   mappings = {
          #     panel = {
          #       open = "<M-CR>";
          #     };
          #   };
          # };
          # codecompanion-nvim.enable = false;
          # avante-nvim.enable = isMaximal;
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
      packages.neovim-nvf =
        (inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [
            self.nixosModules.nvf
          ];
        }).neovim;
    };
}
