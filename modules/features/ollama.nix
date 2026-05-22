{
  self,
  inputs,
  pkgs,
  ...
}:
{
  flake.nixosModules.ollama =
    { pkgs, ... }:
    let
      ollamaPkg = pkgs.ollama-cpu;
    in
    {
      services.ollama = {
        enable = true;
        package = ollamaPkg;
        loadModels = [
          "deepseek-r1:7b"
          "gemma3:4b"
          "gemma4:e4b"
        ];
        host = "0.0.0.0";
        openFirewall = true;
      };
      services.open-webui = {
        enable = true;
        port = 8080;
        environment = {
          OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
          WEBUI_AUTH = "False";
          # privacy settings
          ANONYMIZED_TELEMETRY = "False";
          DO_NOT_TRACK = "True";
          SCARF_NO_ANALYTICS = "True";

          # OPENAI_API_BASE_URL = "https://api.anthropic.com/v1";
          # OPENAI_API_KEY = "sk-ant-xxxxxxxxxxxxxxxxxxxx"; # Replace with your actual key
        };
        openFirewall = true;
      };
    };
}
