{ self, inputs, ... }: {
  perSystem = { self', pkgs, ... }: {
    packages.zoxide = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.zoxide;
      env = {
        _ZO_DATA_DIR = "~/.local/share/zoxide/db.zo";
      };
    };
  };
}
