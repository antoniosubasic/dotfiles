{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.sqldeveloper;
  pkg = pkgs.callPackage ./package.nix { };
in
{
  options.programs.sqldeveloper = {
    enable = mkEnableOption "Oracle SQL Developer";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkg ];

    environment.sessionVariables = {
      JAVA_HOME = "${pkgs.openjdk17}";
    };
  };
}
