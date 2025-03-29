{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "open" ''
      if [ -z "''$1" ]; then
        read input
        param="''$input"
      else
        param="''$1"
      fi

      ${pkgs.xdg-utils}/bin/xdg-open "''$param"
    '')

    (pkgs.writeShellScriptBin "files" ''
      path="''${1:-.}"

      if [ -e "''$path" ]; then
        ${pkgs.xdg-utils}/bin/xdg-open "''$path"
      else
        echo "not a valid file or directory"
        exit 1
      fi
    '')

    (pkgs.writeShellScriptBin "locate" ''
      if [ -z "''$1" ]; then
        echo "usage: ''$(${pkgs.coreutils}/bin/basename "''$0") <image>"
        exit 1
      fi

      if [ -f "''$1" ]; then
        pos=''$(${pkgs.exiftool}/bin/exiftool -GPSPosition "''$1" | ${pkgs.gawk}/bin/awk -F": " '{printf ''$2}' | ${pkgs.gnused}/bin/sed -e "s| deg|°|g")
        if [ -z "''$pos" ]; then
          echo "no GPS position found"
          exit 1
        fi

        printf "%s\n%s\n" "''$pos" "https://www.google.com/maps/place/''$(echo "''$pos" | ${pkgs.gnused}/bin/sed -e "s|°|%C2%B0|g" -e "s|'|%27|g" -e "s|\"|%22|g" -e "s|,|+|g" -e "s| ||g")"
      else
        echo "file not found: ''$1"
        exit 2
      fi
    '')
  ];
}
