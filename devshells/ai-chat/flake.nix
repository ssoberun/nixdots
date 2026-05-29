{
  description = "Scoped AI Workspace";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        # Keep this folder's devshell lean
        buildInputs = [ pkgs.aichat ];

        shellHook = ''
          # Load your secure API keys ONLY within this directory session
          export GEMINI_API_KEY="your-actual-api-key-here"
          export CLAUDE_API_KEY="your-actual-claude-key-here"

          echo "🤖 Switched to AI Workspace. Keys loaded securely."
          echo "Tip: Use 'aichat' to chat, or '.model gemini:gemini-1.5-pro' to switch models!"
        '';
      };
    };
}
