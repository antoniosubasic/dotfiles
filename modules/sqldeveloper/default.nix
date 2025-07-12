{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.sqldeveloper;
  pkg = pkgs.callPackage ./package.nix {
    scale = cfg.scale;
  };
in
{
  options.programs.sqldeveloper = {
    enable = mkEnableOption "Oracle SQL Developer";

    scale = mkOption {
      type = types.nullOr types.number;
      default = null;
      example = 2;
      description = ''
        Scale factor for HiDPI displays. Sets GDK_SCALE environment variable.
        Common values are 1.0 (normal), 1.5, 2.0 (double scaling), etc.
        If null, GDK_SCALE will not be set.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkg ];

    environment.sessionVariables = {
      JAVA_HOME = "${pkgs.openjdk17}";
    };
  };
}
