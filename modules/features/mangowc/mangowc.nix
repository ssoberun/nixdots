{ inputs, self, ... }: {
  flake.nixosModules.mangowc = { lib, pkgs, ... }: {
    programs.mangowc = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.mangowc;
    };

    # systemd.user.units."mangowc.service" = {
    #   overrideStrategy = lib.mkDefault "asDropin";
    #
    # };
  };
  perSystem =
    {
      self',
      pkgs,
      lib,
      ...
    }:
    let
      noctaliaExe = lib.getExe inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      packages.mangowc = inputs.wrapper-modules.wrappers.mangowc.wrap {
        inherit pkgs;
        package = pkgs.mango;
        autostart_sh =
          # sh
          ''
            ${noctaliaExe}
          '';
        settings =
          let
            mainMod = "SUPER";
            secondaryMod = "ALT";
            terminalExe = lib.getExe self'.packages.terminal;
            screenshot-sh = lib.getExe self'.packages.screenshot-tool;
          in
          {
            # mouse and kb
            mouse_natural_scrolling = 0;
            mouse_accel_speed = -0.5;

            repeat_rate = 40;
            repeat_delay = 200;
            numlockon = 0;
            xkb_rules_layout = "us,ru,ua";
            xkb_rules_options = "grp:alt_shift_toggle";

            # layout
            # https://mangowm.github.io/docs/window-management/layouts#configuration
            # "scroller_default_proportion" = 0.55;
            # "scroller_focus_center" = 1;
            scroller_proportion_preset = "0.5, 0.8, 1.0";
            scroller_default_proportion = 0.8;
            scroller_focus_center = 0;
            scroller_prefer_center = 0;
            edge_scroller_pointer_focus = 1;
            scroller_default_proportion_single = 1.0;

            new_is_master = 1;
            default_mfact = 0.55;
            default_nmaster = 1;
            smartgaps = 1;

            hotarea_size = 10;
            enable_hotarea = 0;
            ov_tab_mode = 1;
            overviewgappi = 5;
            overviewgappo = 30;

            no_border_when_single = 0;
            axis_bind_apply_timeout = 100;
            focus_on_activate = 0;
            idleinhibit_ignore_visible = 0;
            sloppyfocus = 1;
            warpcursor = 1;
            focus_cross_monitor = 0;
            focus_cross_tag = 0;
            enable_floating_snap = 0;
            snap_distance = 30;
            cursor_size = 24;
            drag_tile_to_tile = 1;

            gappih = 3;
            gappiv = 3;
            gappoh = 3;
            gappov = 3;
            scratchpad_width_ratio = 0.8;
            scratchpad_height_ratio = 0.9;
            borderpx = 2;
            # animations

            animations = 1;
            layer_animations = 1;
            animation_type_open = "slide";
            animation_type_close = "slide";
            tag_animation_direction = 1;
            zoom_initial_ratio = 0.4;
            zoom_end_ratio = 0.8;

            animation_fade_in = 0;
            animation_fade_out = 0;
            # animation_fade_in = 1;
            # animation_fade_out = 1;

            fadein_begin_opacity = 0.5;
            fadeout_begin_opacity = 0.8;

            animation_duration_move = 250;
            animation_duration_open = 200;
            animation_duration_tag = 125;
            animation_duration_close = 275;
            animation_duration_focus = 0;

            # animation_duration_move = 500;
            # animation_duration_open = 400;
            # animation_duration_tag = 350;
            # animation_duration_close = 800;
            # animation_duration_focus = 0;

            animation_curve_open = "0.46,1.0,0.29,1";
            animation_curve_move = "0.46,1.0,0.29,1";
            animation_curve_tag = "0.46,1.0,0.29,1";
            animation_curve_close = "0.08,0.92,0,1";
            animation_curve_focus = "0.46,1.0,0.29,1";
            animation_curve_opafadeout = "0.5,0.5,0.5,0.5";
            animation_curve_opafadein = "0.46,1.0,0.29,1";

            # animation_curve_open = "0.1,0.9,0.1,1";
            # animation_curve_move = "0.1,0.9,0.1,1";
            # animation_curve_tag = "0.1,0.9,0.1,1";
            # animation_curve_close = "0.1,0.9,0.1,1";
            # animation_curve_focus = "0.1,0.9,0.1,1";
            # animation_curve_opafadeout = "0.5,0.5,0.5,0.5";
            # animation_curve_opafadein = "0.1,0.9,0.1,1";

            circle_layout = "scroller,tile,grid";
            # env=GTK_IM_MODULE,fcitx
            # env=QT_IM_MODULE,fcitx
            # env=QT_IM_MODULES,wayland;fcitx
            # env=SDL_IM_MODULE,fcitx
            # env=XMODIFIERS,@im=fcitx
            # env=GLFW_IM_MODULE,ibus

            tagrule = [
              "id:1,layout_name:scroller"
              "id:2,layout_name:scroller"
              "id:3,layout_name:scroller"
              "id:4,layout_name:scroller"
              "id:5,layout_name:scroller"
              "id:6,layout_name:scroller"
              "id:7,layout_name:scroller"
              "id:8,layout_name:scroller"
              "id:9,layout_name:scroller"
              "id:10,layout_name:scroller"
            ];

            bind = [
              "${mainMod},Return,spawn,${terminalExe}"
              "${mainMod},Space,spawn,${noctaliaExe} msg panel-toggle launcher"
              "${mainMod},n,switch_layout"

              # screenshot
              # "${mainMod},PRINT,spawn,${screenshot-sh}"
              "${mainMod}, PRINT, spawn, ${screenshot-sh} fullscreen"
              "SHIFT, PRINT, spawn, ${screenshot-sh} region"
              "CTRL+SHIFT, PRINT, spawn, ${screenshot-sh} window"
              "CTRL+${mainMod}, PRINT, spawn, ${screenshot-sh} freeze"
              "SHIFT+${mainMod}, PRINT, spawn, ${screenshot-sh} freeze-region"
              "NONE,PRINT, spawn, ${screenshot-sh} annotate"

              "${mainMod},o,toggleoverview"
              "${mainMod},t,toggleglobal"
              "${mainMod},z,toggle_scratchpad"

              "${mainMod},e,set_proportion,1.0"
              "${mainMod},x,switch_proportion_preset"

              "${mainMod},m,quit"
              "${mainMod},q,killclient"

              # "${mainMod},F,togglefakefullscreen"
              "${mainMod},F,togglemaximizescreen"
              "${mainMod},G,togglefullscreen"
              "${mainMod}+SHIFT,F,togglefloating"

              "${mainMod},h,focusdir,left"
              "${mainMod},l,focusdir,right"
              "${mainMod},k,focusdir,up"
              "${mainMod},j,focusdir,down"

              "${mainMod},Left,focusdir,left"
              "${mainMod},Right,focusdir,right"
              "${mainMod},Up,focusdir,up"
              "${mainMod},Down,focusdir,down"

              "${mainMod}+SHIFT,Up,exchange_client,up"
              "${mainMod}+SHIFT,Down,exchange_client,down"
              "${mainMod}+SHIFT,Left,exchange_client,left"
              "${mainMod}+SHIFT,Right,exchange_client,right"

              "${mainMod}+SHIFT,k,exchange_client,up"
              "${mainMod}+SHIFT,j,exchange_client,down"
              "${mainMod}+SHIFT,h,exchange_client,left"
              "${mainMod}+SHIFT,l,exchange_client,right"

              "${mainMod}+CTRL,h,resizewin,-50,+0"
              "${mainMod}+CTRL,l,resizewin,+50,+0"
              "${mainMod}+CTRL,k,resizewin,+0,-50"
              "${mainMod}+CTRL,j,resizewin,+0,+50"

              "${mainMod},1,view,1,0"
              "${mainMod},2,view,2,0"
              "${mainMod},3,view,3,0"
              "${mainMod},4,view,4,0"
              "${mainMod},5,view,5,0"
              "${mainMod},6,view,6,0"
              "${mainMod},8,view,7,0"
              "${mainMod},9,view,8,0"
              "${mainMod},0,view,9,0"

              "${mainMod}+SHIFT,1,tag,1,0"
              "${mainMod}+SHIFT,2,tag,2,0"
              "${mainMod}+SHIFT,3,tag,3,0"
              "${mainMod}+SHIFT,4,tag,4,0"
              "${mainMod}+SHIFT,5,tag,5,0"
              "${mainMod}+SHIFT,6,tag,6,0"
              "${mainMod}+SHIFT,8,tag,7,0"
              "${mainMod}+SHIFT,9,tag,8,0"
              "${mainMod}+SHIFT,0,tag,9,0"

              "NONE,XF86MonBrightnessDown,spawn,${lib.getExe pkgs.brightnessctl} set -5%"
              "NONE,XF86MonBrightnessUp,spawn,${lib.getExe pkgs.brightnessctl} set +5%"

            ];
            bindl = [
              "NONE,XF86AudioRaiseVolume,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 && wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ --limit 1.0"
              "NONE,XF86AudioLowerVolume,spawn,wpctl"
              "NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              "NONE,XF86AudiomicMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

              "NONE,XF86AudioNext,spawn,${lib.getExe pkgs.playerctl} next"
              "NONE,XF86AudioPrev,spawn,${lib.getExe pkgs.playerctl} previous"
              "NONE,XF86AudioPlay,spawn,${lib.getExe pkgs.playerctl} play-pause"
            ];
            mousebind = [
              "SUPER,btn_left,moveresize,curmove"
              "SUPER,btn_right,moveresize,curresize"
            ];

            axisbind = [
              "SUPER,UP,viewtoleft_have_client"
              "SUPER,DOWN,viewtoright_have_client"
              # "SUPER+CTRL,UP,spawn,${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.vol} up"
              # "SUPER+CTRL,DOWN,spawn,${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.vol} down"
            ];
          };
      };
    };
}
