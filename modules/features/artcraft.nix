{ self, inputs, ... }:
{
  flake.nixosModules.artcraft = { pkgs, ... }: {
    imports = [ inputs.nix-craftapps.nixosModules.default ];
    programs.craftapps = {
      enable = true;
      apps.photocraft.enable = true;
      apps.vectorcraft.enable = true;
      apps.pdfcraft.enable = true;
    };
    # environment.systemPackages = with pkgs; [
    #   pdfcraft
    #   vectorcraft
    #   photocraft
    #   wordcraft
    # ];
  };
}
