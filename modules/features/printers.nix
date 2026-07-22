{
  flake.nixosModules.core = { config, pkgs, ... }: {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.printing = {
      enable = true;
      browsed.enable = true;
      drivers = with pkgs; [
        cups-filters
        gutenprint
        gutenprintBin
        hplip
        hplipWithPlugin
        postscript-lexmark
        samsung-unified-linux-driver
        splix
        brlaser
        brgenml1lpr
        brgenml1cupswrapper
        cnijfilter2
        epson-escpr
        epson-escpr2
      ];
    };

  };
}
