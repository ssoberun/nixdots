{ inputs, ... }:
{
  flake.nixosModules.flatpak =
    { pkgs, ... }:
    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
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
        ];
        # overrides = {
        #   "org.vinegarhq.Vinegar" = {
        #     Context = {
        #       sockets = [ "!wayland" ];
        #     };
        #   };
        # };
        update.onActivation = true;
      };
    };
}
