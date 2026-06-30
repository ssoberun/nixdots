{
  flake.nixosModules.office = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      unoconv
      libreoffice
    ];
  };
}
