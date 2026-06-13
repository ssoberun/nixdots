{
  colorize_brackets = true;
  code_lens = "on";
  toolbar = {
    code_actions = true;
  };
  show_signature_help_after_edits = true;
  auto_signature_help = true;
  redact_private_values = true;
  cli_default_open_behavior = "existing_window";
  edit_predictions = {
    provider = "zed";
  };
  agent_servers = {
    pi-acp = {
      type = "registry";
    };
    kilo = {
      type = "registry";
    };
    github-copilot-cli = {
      type = "registry";
    };
    gemini = {
      type = "registry";
    };
    cursor = {
      type = "registry";
    };
    codex-acp = {
      type = "registry";
    };
    claude-acp = {
      type = "registry";
    };
    amp-acp = {
      type = "registry";
    };
    factory-droid = {
      type = "registry";
    };
    github-copilot = {
      type = "registry";
    };
    opencode = {
      favorite_config_option_values = {
        model = [ "opencode-go/glm-5.1" ];
      };
      type = "registry";
    };
  };
  session = {
    trust_all_worktrees = true;
  };
  git = {
    inline_blame = {
      enabled = true;
    };
  };
  status_bar = {
    "experimental.show" = false;
  };
  gutter = {
    line_numbers = true;
  };
  cursor_shape = "bar";
  cursor_blink = true;
  use_system_window_tabs = true;
  buffer_font_fallbacks = [
    "Maple Mono NF"
    "JetBrainsMono Nerd Font Mono"
    "Menlo"
    "Monaco"
    "Courier New"
  ];
  show_whitespaces = "all";
  show_edit_predictions = true;
  hard_tabs = true;
  git_panel = {
    tree_view = true;
    dock = "right";
  };
  icon_theme = {
    mode = "dark";
    light = "Catppuccin Mocha";
    dark = "Catppuccin Mocha";
  };
  base_keymap = "VSCode";
  theme = {
    mode = "dark";
    light = "Maple Light";
    # dark = "Maple Dark";
    dark = "One Dark";
  };
  ui_font_size = 17;
  buffer_font_size = 18.5;
  file_finder = {
    modal_max_width = "medium";
  };
  buffer_font_family = "Maple Mono NF";
  vim_mode = true;
  vim = { };
  which_key = {
    delay_ms = 500;
    enabled = true;
  };
  relative_line_numbers = "enabled";
  tab_bar = {
    show = true;
  };
  scrollbar = {
    show = "never";
  };
  tabs = {
    show_diagnostics = "errors";
  };
  indent_guides = {
    enabled = true;
    coloring = "indent_aware";
  };
  centered_layout = {
    left_padding = 0.15;
    right_padding = 0.15;
  };
  agent = {
    default_profile = "write";
    favorite_models = [
      {
        provider = "opencode";
        model = "go/minimax-m2.7";
        enable_thinking = false;
      }
      {
        provider = "opencode";
        model = "go/glm-5.1";
        enable_thinking = false;
      }
      {
        provider = "CrofAI";
        model = "kimi-k2.6";
        enable_thinking = false;
      }
      {
        provider = "CrofAI";
        model = "glm-5.1";
        enable_thinking = false;
      }
      {
        provider = "CrofAI";
        model = "deepseek-v4-pro";
        enable_thinking = false;
      }
      {
        provider = "opencode";
        model = "go/kimi-k2.6";
        enable_thinking = false;
      }
    ];
    dock = "left";
    inline_assistant_model = {
      provider = "ollama";
      model = "gpt-oss:120b-cloud";
    };
    default_model = {
      provider = "opencode";
      model = "free/minimax-m2.5-free";
    };
  };
  language_models = {
    opencode = {
      show_zen_models = false;
    };
    ollama = {
      api_url = "http://localhost:11434";
    };
    openai_compatible = {
      CrofAI = {
        api_url = "https://crof.ai/v1";
        available_models = [
          {
            name = "kimi-k2.6";
            display_name = "Kimi K2.6";
            max_tokens = 262144;
            capabilities = {
              tools = true;
              images = true;
              parallel_tool_calls = true;
              prompt_cache_key = true;
            };
          }
          {
            name = "kimi-k2.6-precision";
            display_name = "Kimi K2.6 Precision";
            max_tokens = 262144;
            capabilities = {
              tools = true;
              images = true;
              parallel_tool_calls = true;
              prompt_cache_key = true;
            };
          }
          {
            name = "qwen3.5-397b-a17b";
            display_name = "Qwen 3.5";
            max_tokens = 262144;
            capabilities = {
              tools = true;
              images = true;
              parallel_tool_calls = true;
              prompt_cache_key = true;
            };
          }
          {
            name = "deepseek-v4-pro";
            display_name = "Deepseek V4 Pro";
            max_tokens = 10000000;
          }
          {
            name = "deepseek-v4-pro-precision";
            display_name = "Deepseek V4 Pro Precision";
            max_tokens = 10000000;
          }
          {
            name = "glm-5.1-precision";
            display_name = "GLM 5.1 Precision";
            max_tokens = 202752;
          }
          {
            name = "glm-5.1";
            display_name = "GLM 5.1";
            max_tokens = 202752;
          }
          {
            name = "qwen3.6-27b";
            display_name = "Qwen 3.6";
            max_tokens = 262144;
            capabilities = {
              tools = true;
              images = true;
              parallel_tool_calls = true;
              prompt_cache_key = true;
            };
          }
        ];
      };
    };
  };
  inlay_hints = {
    enabled = true;
  };
  lsp = {
    tailwindcss-language-server = {
      settings = {
        classAttributes = [
          "class"
          "className"
          "ngClass"
          "styles"
        ];
      };
    };
  };
  languages = {
    TypeScript = {
      show_whitespaces = "all";
      show_edit_predictions = true;
      hard_tabs = true;
      inlay_hints = {
        enabled = true;
        show_parameter_hints = false;
        show_other_hints = true;
        show_type_hints = true;
      };
    };
    Python = {
      show_whitespaces = "all";
      show_edit_predictions = true;
      hard_tabs = true;
      format_on_save = "on";
      formatter = {
        language_server = {
          name = "ruff";
        };
      };
      language_servers = [
        "ty"
        "ruff"
        "!basedpyright"
        "!pyrefly"
        "!pyright"
        "!pylsp"
      ];
    };
    nix = {
      language_servers = [
        "nixd"
        "nil"
      ];
    };
  };
  terminal = {
    shell = {
      program = "/Users/huynhdung/.cargo/bin/codemux";
    };
    show_count_badge = true;
    font_size = 17.0;
    font_family = "Maple Mono NF";
    env = {
      EDITOR = "zed --wait";
    };
  };
  file_types = {
    Dockerfile = [
      "Dockerfile"
      "Dockerfile.*"
    ];
    JSON = [
      "json"
      "jsonc"
      "*.code-snippets"
    ];
  };
  file_scan_exclusions = [
    "**/.git"
    "**/.svn"
    "**/.hg"
    "**/CVS"
    "**/.DS_Store"
    "**/Thumbs.db"
    "**/.classpath"
    "**/.settings"
    "**/out"
    "**/dist"
    "**/.husky"
    "**/.turbo"
    "**/.vscode-test"
    "**/.vscode"
    "**/.next"
    "**/.storybook"
    "**/.tap"
    "**/.nyc_output"
    "**/report"
    "**/node_modules"
  ];
  telemetry = {
    diagnostics = true;
    metrics = false;
  };
  project_panel = {
    auto_fold_dirs = false;
    button = true;
    dock = "right";
    git_status = true;
  };
  outline_panel = {
    dock = "right";
  };
  collaboration_panel = {
    dock = "right";
  };
  context_servers = {
    react-grab-mcp = {
      command = "npx";
      args = [
        "-y"
        "@react-grab/mcp"
        "--stdio"
      ];
      env = { };
    };
  };
}
