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
        ];
        update.onActivation = true;
      };
    };
}
