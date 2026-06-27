{ self, inputs, ... }: {
  flake.nixosModules.looking-glass =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      # From https://wiki.nixos.org/wiki/Looking_Glass
      # Loading
      boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
      boot.initrd.kernelModules = [ "kvmfr" ];
      boot.kernelParams = [ "kvmfr.static_size_mb=64" ]; # replace with your calculated MEM requirement
      # Permissions
      services.udev.packages = lib.singleton (
        pkgs.writeTextFile {
          name = "kvmfr";
          text = ''
            SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660", TAG+="uaccess"
          '';
          destination = "/etc/udev/rules.d/70-kvmfr.rules";
        }
      );

      virtualisation.libvirtd.qemu = {
        verbatimConfig = ''
          namespaces = []
          cgroup_device_acl = [
            "/dev/null", "/dev/full", "/dev/zero",
            "/dev/random", "/dev/urandom",
            "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
            "/dev/rtc","/dev/hpet", "/dev/vfio/vfio",
            "/dev/kvmfr0"
          ]
        '';
      };

      environment.systemPackages = with pkgs; [
        looking-glass-client
      ];
    };
}
