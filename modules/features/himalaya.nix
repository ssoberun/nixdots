{ self, inputs, ... }:
{
  flake.nixosModules.core =
    { config, pkgs, ... }:
    {
      hj.xdg.config.files."himalaya/config.toml" = {
        generator = value: (pkgs.formats.toml { }).generate "himalaya-config.toml" value;

        value = {
          accounts = {
            "Sam Pounder" =
              let
                # address-source = builtins.readFile config.sops.secrets."email-accounts/SamPounder/email".path;
                address-source = "5744sam@gmail.com";
                email = address-source;
                login = address-source;
              in
              {
                default = true;
                inherit email;
                display-name = "5744sam";
                downloads-dir = "/home/sam/Downloads";

                backend = {
                  type = "imap";
                  host = "imap.gmail.com";
                  port = 993;
                  inherit login;
                  encryption.type = "tls";
                  auth = {
                    type = "password";
                    command = "cat ${config.sops.secrets."email-accounts/SamPounder/IMAP".path}";
                  };
                };

                message.send.backend = {
                  type = "smtp";
                  host = "smtp.gmail.com";
                  port = 465;
                  inherit login;
                  encryption.type = "tls";
                  auth = {
                    type = "password";
                    command = "cat ${config.sops.secrets."email-accounts/SamPounder/SMTP".path}";
                  };
                };
              };
            "BiggEmployee" =
              let
                # address-source = builtins.readFile config.sops.secrets."email-accounts/BiggEmployee/email".path;
                address-source = "biggemployee@gmail.com";
                email = address-source;
                login = address-source;
              in
              {
                default = true;
                inherit email;
                display-name = "big employee";
                downloads-dir = "/home/sam/Downloads";

                backend = {
                  type = "imap";
                  host = "imap.gmail.com";
                  port = 993;
                  inherit login;
                  encryption.type = "tls";
                  auth = {
                    type = "password";
                    command = "cat ${config.sops.secrets."email-accounts/BiggEmployee/IMAP".path}";
                  };
                };

                message.send.backend = {
                  type = "smtp";
                  host = "smtp.gmail.com";
                  port = 465;
                  inherit login;
                  encryption.type = "tls";
                  auth = {
                    type = "password";
                    command = "cat ${config.sops.secrets."email-accounts/BiggEmployee/SMTP".path}";
                  };
                };
              };

            # IMAP disabled for schoolsnet domain :(
            # "Sam EDU" =
            #   let
            #     email = "REDACTED";
            #     login = "REDACTED";
            #   in
            #   {
            #     default = true;
            #     inherit email;
            #     display-name = "REDACTED";
            #     downloads-dir = "/home/sam/Downloads";
            #
            #     backend = {
            #       type = "imap";
            #       host = "imap.gmail.com";
            #       port = 993;
            #       inherit login;
            #       encryption.type = "tls";
            #       auth = {
            #         type = "password";
            #         command = "cat ${config.sops.secrets."email-accounts/sam-edu/IMAP".path}";
            #       };
            #     };
            #
            #     message.send.backend = {
            #       type = "smtp";
            #       host = "smtp.gmail.com";
            #       port = 465;
            #       inherit login;
            #       encryption.type = "tls";
            #       auth = {
            #         type = "password";
            #         command = "cat ${config.sops.secrets."email-accounts/sam-edu/SMTP".path}";
            #       };
            #     };
            #   };
          };
        };
      };
    };

  perSystem =
    { self', pkgs, ... }:
    {
      packages.himalaya = inputs.wrapper-modules.wrappers.himalaya.wrap {
        inherit pkgs;
      };
    };
}
