{ self, inputs, ... }:
{
  flake.nixosModules.mySops =
    { pkgs, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.sops
      ];

      # environment.systemPackages = [
      #   pkgs.sops
      # ];
      sops = {
        # package = pkgs.sops;
        defaultSopsFile = ../../secrets/secrets.yaml;
        defaultSopsFormat = "yaml";

        age = {
          keyFile = "/home/sam/nixdots/secrets/keys.txt";
          generateKey = false;
        };

        secrets = {
          "ai_keys/gemini_api_key" = {
            owner = "sam";
          };
          "qui-session" = {
            owner = "sam";
          };

          # emails
          # sam Pounder
          "email-accounts/SamPounder/email" = {
            owner = "sam";
          };
          "email-accounts/SamPounder/IMAP" = {
            owner = "sam";
          };
          "email-accounts/SamPounder/SMTP" = {
            owner = "sam";
          };

          "email-accounts/BiggEmployee/email" = {
            owner = "sam";
          };
          "email-accounts/BiggEmployee/IMAP" = {
            owner = "sam";
          };
          "email-accounts/BiggEmployee/SMTP" = {
            owner = "sam";
          };
          "users/sam-password" = {
            owner = "sam";
            neededForUsers = true;
          };
          # "email-accounts/sam-edu/IMAP" = {
          #   owner = "sam";
          # };
          # "email-accounts/sam-edu/SMTP" = {
          #   owner = "sam";
          # };

          github_ssh_key = {
            path = "/home/sam/.ssh/id_ed25519";
            owner = "sam";
          };
        };
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.sops = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.sops;
        # Environment baked into the package itself
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
