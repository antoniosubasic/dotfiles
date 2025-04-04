{ lib, utils, ... }:

lib.mkIf (utils.hasTag "personal") {
  home.activation.copyTemplates = lib.mkAfter ''
    rm -rf $HOME/Templates/*
    cp -r ${./files/templates}/* $HOME/Templates/
  '';
}
