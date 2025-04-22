{ lib, tags }:

rec {
  importNixFiles =
    dir:
    let
      nixFiles = builtins.filter (name: lib.hasSuffix ".nix" name) (
        builtins.attrNames (builtins.readDir dir)
      );

      importPaths = map (name: "${dir}/${name}") nixFiles;
    in
    map (path: import path) importPaths;

  hasTag = tag: builtins.elem "bt_${tag}" tags;
  hasTags = tagList: lib.all hasTag tagList;
}
