{ self, inputs, pkgs,... }: {
  flake.nixosModules.sops = { pkgs, lib, ... }: {
    imports = [ inputs.sops-nix.nixosModules.sops ];
    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";

      age.keyFile = "/home/sam/nixdots/secrets/keys.txt";
    };
  };
}
