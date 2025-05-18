{
  osConfig,
  pkgs,
  lib,
  utilities,
  ...
}:

lib.optionalAttrs (utilities.hasTag "shell") {
  home.packages =
    [
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
    ]
    ++ lib.optionals (utilities.hasTag "gui") [
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
    ]
    ++ lib.optionals (osConfig.programs.nh.enable && osConfig.programs.nh.flake != null) [
      (pkgs.writeShellScriptBin "build" ''
        update=false
        shutdown=false
        for arg in "''$@"; do
          case "''$arg" in
            -u|--update) update=true ;;
            -s|--shutdown) shutdown=true ;;
            -us|-su) update=true; shutdown=true ;;
            *)
              echo "unknown option: ''$arg"
              echo "usage: build [-u|--update] [-s|--shutdown]"
              exit 1
              ;;
          esac
        done

        if [[ "''$update" == true ]]; then
          if [ -n "''$(${pkgs.git}/bin/git -C "${osConfig.programs.nh.flake}" status --porcelain)" ]; then
            echo "uncommitted changes detected"
            exit 1
          fi

          ${pkgs.git}/bin/git -C "${osConfig.programs.nh.flake}" pull
          if [ $? -ne 0 ]; then
            echo "pulling remote failed"
            exit 1
          fi

          ${pkgs.nix}/bin/nix flake update --flake "${osConfig.programs.nh.flake}"
          if [ $? -ne 0 ]; then
            echo "updating flake.lock failed"
            exit 1
          fi

          if [ -n "''$(${pkgs.git}/bin/git -C "${osConfig.programs.nh.flake}" status --porcelain)" ]; then
            ${pkgs.git}/bin/git -C "${osConfig.programs.nh.flake}" commit -m "bump(flake): update flake.lock" flake.lock
            if [ $? -ne 0 ]; then
              echo "committing flake.lock failed"
              exit 1
            fi

            ${pkgs.git}/bin/git -C "${osConfig.programs.nh.flake}" push
            if [ $? -ne 0 ]; then
              echo "pushing flake.lock failed"
              exit 1
            fi
          fi
        fi

        if [[ "''$shutdown" == true ]]; then
          systemd-inhibit --what=idle:sleep:handle-lid-switch --why="NixOS rebuild" bash -c '
            outfile="$(mktemp)"
            sudo nixos-rebuild switch --flake "${osConfig.programs.nh.flake}" > ''$outfile 2>&1
            if [ $? -ne 0 ]; then
              cp ''$outfile ~/Desktop/nixos-rebuild-failed-$(date -Iseconds).log
            fi
          '
          shutdown -h now
        else
          systemd-inhibit --what=idle:sleep:handle-lid-switch --why="NixOS rebuild" bash -c '
            ${pkgs.nh}/bin/nh os switch
          '
        fi
      '')
    ];
}
