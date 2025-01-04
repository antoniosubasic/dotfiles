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
        source = ./files/scripts;
      };
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];

    activation.copyTemplates = lib.mkAfter ''
      rm -rf $HOME/Templates/*
      cp -r ${./files/templates}/* $HOME/Templates/
    '';
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