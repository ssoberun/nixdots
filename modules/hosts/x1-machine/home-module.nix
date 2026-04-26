{self, inputs, config, ...}: 
let 
  username = "${config.preferences.user.name}";
in
{
  flake.nixosModules."${username}Module" = {pkgs, ...}: {
    users.users."${username}" = {
      shell = pkgs.fish
    }
  }
}
