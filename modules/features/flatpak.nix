{ inputs, ... }:
{
  flake.nixosModules.flatpak =
    { pkgs, ... }:
    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
      # services.flatpak = {
      #   enable = true;
      #   remotes = [
      #     {
      #       name = "flathub";
      #       location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      #     }
      #   ];
      #   packages = [
      #     "org.vinegarhq.Sober"
      #     "org.vinegarhq.Vinegar"
      #
      #     # nvidia drivers for flatpak
      #     # "runtime/org.freedesktop.Platform.GL.nvidia-595-84/x86_64/1.4"
      #     # "runtime/org.freedesktop.Platform.GL32.nvidia-595-84/x86_64/1.4"
      #   ];
      #   overrides = {
      #     global = {
      #       Environment = {
      #         # Forces the use of the discrete NVIDIA GPU
      #         "__NV_PRIME_RENDER_OFFLOAD" = "1";
      #         "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
      #
      #         # Enables explicit sync protocol features if your Niri version supports it
      #         "DISABLE_NVIDIA_THREADED_OPTIMIZATIONS" = "0";
      #       };
      #     };
      #     "org.vinegarhq.Sober" = {
      #       # Allow Sober to bypass the compositor's VSync if configured in Niri (Tearing)
      #       Context.sockets = [
      #         "wayland"
      #         "fallback-x11"
      #       ];
      #     };
      #   };
      #   update.onActivation = true;
      # };
      services.flatpak = {
        enable = true;

        remotes = [
          {
            name = "flathub";
            location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
          }
        ];

        packages = [
          "org.vinegarhq.Sober"
          "org.vinegarhq.Vinegar"
          "flathub:com.github.tchx84.Flatseal"
          "flathub:org.mozilla.firefox"
        ];

        overrides = {
          "org.vinegarhq.Sober" = {
            # hopefully equivalent to:
            # flatpak override --user --socket=x11 --nosocket=wayland org.vinegarhq.Sober
            # if not run the command
            # should fix stuttering/lag issues
            Context.sockets = [
              "x11"
              "!wayland"
            ];
          };
        };

        update.onActivation = true;
      };
    };
}
