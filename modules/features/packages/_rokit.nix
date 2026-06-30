{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "rokit";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "rojo-rbx";
    repo = "rokit";
    rev = "v${version}";
    hash = "sha256-7DVToKKq3omZOlLMIcthAS8PdvJ4zaKKDAU5HbDIEJc=";
  };

  cargoHash = "sha256-117kiiZ3ELP6S7SpNHJUBqqCKkVucxjfSmtRE83Zm/8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.CoreServices
  ];

  meta = with lib; {
    description = "Next-generation toolchain manager for Roblox projects";
    homepage = "https://github.com/rojo-rbx/rokit";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "rokit";
  };
}
