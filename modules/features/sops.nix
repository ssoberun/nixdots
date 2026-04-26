{ self, inputs, ... }: {
  # 1. The NixOS Module
  flake.nixosModules.mySops = { pkgs, ... }: {
    imports = [ inputs.sops-nix.nixosModules.sops ];

    # Install the wrapped sops package from this flake
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.sops
    ];

    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/home/sam/nixdots/secrets/keys.txt";
      
      secrets.github_ssh_key = {
        owner = "sam";
      };
    };
  };

  # 2. The Package Definition (The Wrapper)
  perSystem = { pkgs, ... }: {
    packages.sops = inputs.wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.sops;
      # This ensures that whenever you run 'sops' in the terminal,
      # it already knows where your keys are.
      env.SOPS_AGE_KEY_FILE = "/home/sam/nixdots/secrets/keys.txt";
    };
  };
}

# { self, inputs, ... }:
# {
#   flake.nixosModules.mySops = { pkgs, lib, config, ... }: 
#   let 
#     # Define the wrapper INSIDE the module, where pkgs is already provided by the host
#     sops' = inputs.wrapper-modules.lib.wrapPackage {
#         inherit pkgs;
#         package = pkgs.sops;
# 	env.SOPS_AGE_KEY_FILE = "/home/sam/nixdots/secrets/keys.txt";
#     };
#   in
#   {
#     imports = [ inputs.sops-nix.nixosModules.sops ];
#
#     environment.systemPackages = [ sops' ];
#
#     sops = {
#       # package = pkgs.sops;
#
#       defaultSopsFile = ../../secrets/secrets.yaml;
#       defaultSopsFormat = "yaml";
#       age.keyFile = "/home/sam/nixdots/secrets/keys.txt";
#
#       secrets = {
# 	github_ssh_key = {
# 	  path = "/home/sam/.ssh/github-ssh-key";
# 	  owner = "sam";
# 	};
#       };
#     };
#   };
# }

