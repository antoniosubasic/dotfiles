{ username }: { config, pkgs, lib, ... }:

let
  importNixFiles = dir:
    map (file: dir + "/${file}")
    (builtins.filter (file: lib.hasSuffix ".nix" file)
    (builtins.attrNames (builtins.readDir dir)));

  cli = importNixFiles ./cli;
  gui = importNixFiles ./gui;

  imports = cli ++ gui;
in
{
  imports = imports;

  home = {
    username = username;
    homeDirectory = "/home/${username}";

    file = {
      ".local/share/nvim/parser" = {
        recursive = true;
        enable = true;
        source = pkgs.runCommandNoCC "treesitter-parser-dir" {} ''
          mkdir -p $out
          chmod 755 $out
        '';
      };

      ".local/bin" = {
        source = ./bin;
      };

      "Templates/ERD.pu".text = ''
        @startuml

        !define primary_key(x) <b><color:#b8861b><&key></color> x</b>
        !define foreign_key(x) <color:#aaaaaa><&key></color> x
        !define column(x) <color:#efefef><&media-record></color> x
        !define table(x) entity x << (T, white) >>

        @enduml
      '';
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  fonts.fontconfig.enable = true;

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}