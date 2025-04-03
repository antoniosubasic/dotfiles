{ lib }:

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

  hasTag = tags: tag: builtins.elem tag tags;
  hasTags = tags: tagList: lib.all (hasTag tags) tagList;
}
