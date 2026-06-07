{ inputs, self, ... }:
{
  flake.wrapperModules.oh-my-posh =
    {
      ...
    }:
    {
      # https://birdeehub.github.io/nix-wrapper-modules/wrapperModules/oh-my-posh.html
      order = [
        "theme"
        "file"
        "settings"
      ];
      # themes are set in the --config; see fish.nix
      # settings = {
      #   theme = "darkblood";
      # };
    };
  perSystem =
    { pkgs, ... }:
    {
      packages.oh-my-posh = inputs.wrapper-modules.wrappers.oh-my-posh.wrap {
        inherit pkgs;
        imports = [ self.wrapperModules.oh-my-posh ];
      };
    };
}
