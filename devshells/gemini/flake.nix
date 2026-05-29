{
  description = "Gemini Playground";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux"; # Adjust if you are on aarch64
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nodejs
          gemini-cli
          git
        ];

        shellHook = ''
          echo "Entering Gemini AI Playground"

          export NPM_CONFIG_PREFIX="$PWD/.npm-global"
          export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
          echo "Ready! Type 'gemini' to start, or close with 'exit'."
        '';
      };
    };
}
