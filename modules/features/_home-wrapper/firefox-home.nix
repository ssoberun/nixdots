# modules/programs/bat.nix
{
  flake.modules.homeManager.bat =
    { ... }:
    {
      programs.bat = {
        enable = true;
        config.theme = "ansi";
      };
    };
}
