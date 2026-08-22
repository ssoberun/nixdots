{
  flake.nixosModules.llamacpp = { pkgs, ... }: {
    services.llama-cpp = {
      enable = true;
      openFirewall = true;
      package = pkgs.llama-cpp;
    };
  };
}
