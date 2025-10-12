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
    ];
    gitCredentialHelper.enable = false;
    settings = {
      git_protocol = "ssh";
      editor = config.programs.git.extraConfig.core.editor;
      aliases = {
        c = "repo clone";
        open = "browse";
      };
    };
  };
}
