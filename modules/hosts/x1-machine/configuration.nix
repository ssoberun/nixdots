{ self, inputs, ... }: {
  flake.nixosModules.x1-machine-configuration = { pkgs, lib, config, self', ... }: {
    
    imports = [
      # Hardware and Inputs
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
      self.nixosModules.x1-machine-hardware

      # base
      self.nixosModules.base

      # fonts
      self.nixosModules.fonts
      
      # wrapped modules
      # self.nixosModules.neovim
      self.nixosModules.fish
      self.nixosModules.kitty
      self.nixosModules.GNOME
      self.nixosModules.mySops
      self.nixosModules.env-vars
      self.nixosModules.niri
      self.nixosModules.noctalia # this is to let noctalia be accessed via shell 
      self.nixosModules.git
    ];
    
    # --- Environment & Packages ---
    environment.systemPackages = with pkgs; [
      vim
      neovim
      wget
      age

      firefox
      bitwarden-desktop

      # cursor test
      apple-cursor
    ];
    
    # --- User Configuration ---
    preferences.user.name = "sam";
    users.users = {
      # primary user
      "${config.preferences.user.name}" = {
        isNormalUser = true;
        description = "${config.preferences.user.name}, he is the primary user";
        extraGroups = [ "networkmanager" "wheel" "video" ];
	initialPassword = "password";
      };
      # shell = "${self.packages.${pkgs.stdenv.hostPlatform.system}.shell-environment}/bin/fish";
      # shell = self.packages.${pkgs.stdenv.hostPlatform.system}.fish;
    };

    # --- System Core ---
    networking.hostName = "x1-machine"; 
    networking.networkmanager.enable = true;
    time.timeZone = "Australia/Sydney";
    i18n.defaultLocale = "en_AU.UTF-8";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;

    # --- Boot & Kernel ---
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # --- Feature Toggles ---
    # Assuming you followed the modular sops.nix we discussed:
    features.env-vars.enable = true;

    # --- Desktop Environment ---
    # Note: You have Niri imported, but GDM/GNOME are enabled here.
    # Keep both if you want a fallback, otherwise disable GNOME to stay minimal.
    services.displayManager.ly.enable = true;
    services.xserver = {
      enable = true;
      
      xkb = {
        layout = "au";
        variant = "";
      };
    };

    # --- Sound & Services ---
    services.printing.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    system.stateVersion = "25.11"; 
  };
}
