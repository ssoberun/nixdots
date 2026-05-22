{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wrappers.url = "github:Lassulus/wrappers";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";

    evangelion-ui = {
      url = "gitlab:lobstermane/evangelion-ui-plymouth";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";

    home-manager.url = "github:nix-community/home-manager";
    hm-wrapper-modules.url = "github:sini/hm-wrapper-modules";
    hm-wrapper-modules.inputs.nixpkgs.follows = "nixpkgs";
    hm-wrapper-modules.inputs.home-manager.follows = "home-manager";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
