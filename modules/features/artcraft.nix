{ self, ... }:
{
  flake.nixosModules.artcraft = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      pdfcraft
      vectorcraft
      photocraft
      wordcraft
    ];
  };
}
