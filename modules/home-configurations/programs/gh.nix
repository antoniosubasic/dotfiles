{
  config,
  pkgs,
  utilities,
  ...
}:

{
  programs.gh = {
    enable = utilities.hasTags [
      "shell"
      "personal"
    ];
    extensions = with pkgs; [
      gh-contribs

      (pkgs.writeShellApplication rec {
        name = "gh-ic";
        derivationArgs.pname = name;
        runtimeInputs = with pkgs; [
          jq
          fzf
        ];
        text = ''
          #!/usr/bin/env bash
          selected="$(
            gh api user/repos --paginate | jq -r '.[].full_name' | \
            fzf --preview 'GH_FORCE_TTY=1 gh repo view {}' --expect=enter,alt-enter --bind 'alt-enter:accept'
          )"
          key=$(echo "$selected" | head -1)
          repo=$(echo "$selected" | tail -n +2)
          if [ -n "$repo" ]; then
            if [ "$key" = 'alt-enter' ]; then
              read -r -p 'clone as: ' name
            fi
            if [ -z "''${name+x}" ] || [ -z "$name" ]; then
              gh repo clone "$repo"
            else
              gh repo clone "$repo" "$name"
            fi
          fi
        '';
      })

      (pkgs.writeShellApplication rec {
        name = "gh-open";
        derivationArgs.pname = name;
        runtimeInputs = with pkgs; [
          git
          xdg-utils
          jq
        ];
        text = ''
          #!/usr/bin/env bash
          if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
            if [[ ! " $* " =~ " --branch " ]]; then
              branch=$(git rev-parse --abbrev-ref HEAD)
              default_branch=$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name)
              if [ ! "$branch" = "$default_branch" ]; then
                remote=$(git remote | head -n1)
                if git ls-remote --exit-code --heads "$remote" "$branch" > /dev/null 2>&1; then
                  gh browse --branch "$branch" "$@"
                  exit $?
                fi
              fi
            fi
            gh browse "$@"
          else
            url=$(gh api user | jq -r .html_url)
            echo "Opening $url in your browser."
            xdg-open "$url"
          fi
        '';
      })
    ];
    gitCredentialHelper.enable = false;
    settings = {
      git_protocol = "ssh";
      editor = config.programs.git.extraConfig.core.editor;
      aliases = {
        c = "repo clone";
      };
    };
  };
}
