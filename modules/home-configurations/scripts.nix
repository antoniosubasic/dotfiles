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
      (pkgs.writeShellScriptBin "ns" ''
        if [ $# -eq 0 ]; then
          echo "usage: $(basename "$0") <pkg1> [pkg2] [...]"
          exit 1
        fi

        args=()
        for arg in "$@"; do
          args+=("nixpkgs#$arg")
        done

        ${pkgs.nix}/bin/nix shell "''${args[@]}"
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
      (
        let
          buildParams = {
            update = "Update flake before building";
            test = "Run test build only";
            shutdown = "Shutdown after building (automatically uses now)";
            now = "Authenticate now before building";
            pull = "Pull remote changes before building";
            help = "Show help";
          };
        in
        pkgs.writeShellScriptBin "build" ''
          set -euo pipefail

          ${lib.concatMapStringsSep "\n" (param: "${param}=false") (lib.attrNames buildParams)}
          unknown=false

          for arg in "''$@"; do
            case "''$arg" in
              ${lib.concatMapStringsSep "\n" (
                param: "-${builtins.substring 0 1 param}|--${param}) ${param}=true ;;"
              ) (lib.attrNames buildParams)}
              -*)
                for (( i=1; i<''${#arg}; i++ )); do
                  case "''${arg:''$i:1}" in
                    ${lib.concatMapStringsSep "\n" (
                      param: "${builtins.substring 0 1 param}) ${param}=true ;;"
                    ) (lib.attrNames buildParams)}
                    *)
                      echo "unknown option: -''${arg:''$i:1}"
                      unknown=true
                      break
                      ;;
                  esac
                done
                ;;
              *)
                echo "unknown option: ''$arg"
                unknown=true
                ;;
            esac
          done

          if [[ "''$help" == true ]] || [[ "''$unknown" == true ]]; then
            if [[ "''$unknown" == true ]]; then
              echo ""
            fi

            echo "usage: ''$(basename "''$0") ${
              lib.concatMapStringsSep " " (param: "[-${builtins.substring 0 1 param}|--${param}]") (
                lib.attrNames buildParams
              )
            }"
            echo "options:"
            ${lib.concatMapStringsSep "\n" (
              param:
              "echo \"  -${builtins.substring 0 1 param}, --${param}    $(printf \"%*s\" ${
                builtins.toString (
                  (lib.foldl (a: b: lib.max a (builtins.stringLength b)) 0 (lib.attrNames buildParams))
                  - (builtins.stringLength param)
                )
              }) ${buildParams.${param}}\""
            ) (lib.attrNames buildParams)}

            if [[ "''$unknown" == true ]]; then
              exit 1
            else
              exit 0
            fi
          fi

          if [[ "''$now" == true ]]; then
            sudo -v
          fi

          if [[ "''$pull" == true ]]; then
            if [ -n "''$(${pkgs.git}/bin/git -C "${osConfig.programs.nh.flake}" status --porcelain)" ]; then
              echo "uncommitted changes detected"
              exit 1
            fi

            ${pkgs.git}/bin/git -C "${osConfig.programs.nh.flake}" pull
            if [ $? -ne 0 ]; then
              echo "pulling remote failed"
              exit 1
            fi
          fi

          if [[ "''$update" == true ]]; then
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

          build_mode=''$([[ "''$test" == true ]] && printf "test" || printf "switch")

          if [[ "''$shutdown" == true ]] || [[ "''$now" == true ]]; then
            systemd-inhibit --what=idle:sleep:handle-lid-switch --why="NixOS rebuild" bash -c "
              outfile=\"\$(mktemp)\"
              sudo nixos-rebuild ''$build_mode --flake \"${osConfig.programs.nh.flake}\" |& tee \''$outfile
              if [ \$? -ne 0 ]; then
                cp \''$outfile ~/Desktop/\$(date -Iseconds)-nixos-rebuild.log
              fi
            "
            if [[ "''$shutdown" == true ]]; then
              shutdown -h now
            fi
          else
            systemd-inhibit --what=idle:sleep:handle-lid-switch --why="NixOS rebuild" bash -c "
              ${pkgs.nh}/bin/nh os ''$build_mode
            "
          fi
        ''
      )
    ];
}
