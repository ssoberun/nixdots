{
  flake.nixosModules.core = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      wl-clipboard
      wl-clipboard-x11
      ripgrep
    ];
  };
}
