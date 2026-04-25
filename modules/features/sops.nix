{ self, inputs, ... }: # Remove pkgs from here!
{
  flake.nixosModules.mySops = { pkgs, lib, config, ... }: 
  let 
    # Define the wrapper INSIDE the module, where pkgs is already provided by the host
    sops' = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.sops;
	env.SOPS_AGE_KEY_FILE = "/home/sam/nixdots/secrets/keys.txt";
    };
  in
  {
    imports = [ inputs.sops-nix.nixosModules.sops ];

    environment.systemPackages = [ sops' ];

    sops = {
      # package = pkgs.sops;

      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/home/sam/nixdots/secrets/keys.txt";

      secrets = {
	github_ssh_key = {
	  path = "/home/sam/.ssh/github-ssh-key/";
	  owner = "sam";
	};
      };
    };
  };
}

