{ lib, ... }:

{
  home.activation.copyTemplates = lib.mkAfter ''
    rm -rf $HOME/Templates/*
    cp -r ${./files/templates}/* $HOME/Templates/
  '';
}
