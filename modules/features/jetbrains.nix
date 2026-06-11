{ inputs, ... }:
{
  flake.nixosModules.jetbrains =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        jetbrains.idea # Java, Kotlin, & Polyglot
        jetbrains.pycharm-professional # Python & Data Science
        jetbrains.goland # Go
        jetbrains.clion # C and C++
        jetbrains.rust-rover # Rust
        jetbrains.dataspell # Jupyter & R Data Science
        jetbrains.webstorm # JS / TS / Web Dev
        jetbrains.datagrip # Databases & SQL
        jetbrains.rider # C# & .NET
        jetbrains.phpstorm # PHP
        jetbrains.rubymine # Ruby
      ];
    };
}
