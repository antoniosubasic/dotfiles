{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:

{
  programs.zsh = {
    enable = osConfig.programs.zsh.enable;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;

    shellAliases = {
      ":q" = "exit";
      nohist = "HISTFILE=/dev/null";
      b = "build";
      conf = "man configuration.nix";
      hconf = "man home-configuration.nix";
      nd = "nix develop";
    }
    // builtins.listToAttrs (
      map (n: {
        name = "${if n == 1 then "" else toString n}..";
        value = "cd ${lib.concatStrings (builtins.genList (_: "../") n)}";
      }) (lib.range 1 9)
    )
    // lib.optionalAttrs (config.programs.eza.enable) {
      ls = "eza";
      ll = "ls -al";
      tree = "ls -T";
    }
    // lib.optionalAttrs (config.programs.ripgrep.enable) {
      grep = "rg";
    }
    // lib.optionalAttrs (builtins.elem pkgs.asciidoctor config.home.packages) {
      adoc = "asciidoctor";
    }
    // lib.optionalAttrs (config.programs.fastfetch.enable) {
      neofetch = "fastfetch -c neofetch.jsonc";
    }
    // lib.optionalAttrs (config.programs.bat.enable) {
      cat = "bat";
      man = "batman";
      diff = "batdiff";
    }
    // lib.optionalAttrs (builtins.elem pkgs.tokei config.home.packages) {
      cloc = "tokei";
    }
    // lib.optionalAttrs (builtins.elem pkgs.wl-clipboard osConfig.environment.systemPackages) {
      copy = "wl-copy -t text/plain";
      paste = "wl-paste -t text/plain";
    }
    // lib.optionalAttrs (builtins.elem pkgs.xh osConfig.environment.systemPackages) {
      http = "xh";
    }
    // lib.optionalAttrs (osConfig.programs.nh.enable) {
      clean = "nh clean all ${osConfig.programs.nh.clean.extraArgs}";
    };

    history = {
      size = 500;
      save = 500;
      append = true;
      ignoreSpace = true;
      ignoreDups = true;
      ignoreAllDups = true;
      expireDuplicatesFirst = true;
      share = true;
      extended = true;
      ignorePatterns = [
        "history"
        "pwd"
        "exit"
        ":q"
        "clear"
        "nohist"
      ];
    };

    completionInit = "autoload -Uz compinit && autoload -Uz vcs_info && compinit";
    defaultKeymap = "emacs";

    initContent = ''
      precmd() { vcs_info }

      # removes confirmation when using `rm -rf *`
      setopt rm_star_silent

      # zsh prompt
      zstyle ':vcs_info:*' enable git
      zstyle ':vcs_info:*' check-for-changes true
      zstyle ':vcs_info:git:*' unstagedstr '*'
      zstyle ':vcs_info:git:*' stagedstr '+'
      zstyle ':vcs_info:git:*' formats ' %F{yellow}(%b)%f' # %b = branch, %c = +, %u = *

      # zsh completion
      zstyle ':completion:*' completer _complete
      zstyle ':completion:*' matcher-list '''''' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

      setopt PROMPT_SUBST
      PROMPT='%F{blue}%~%f''${vcs_info_msg_0_}%(?.%F{green}.%F{red}) ❯%f '

      shutdown() {
        if [ ''$# -eq 0 ]; then
          command shutdown -h now
        else
          command shutdown ''$@
        fi
      }

      # bash like keybindings (https://www.enlinux.com/bash-keyboard-shortcuts)
      bindkey "^T" transpose-chars
      bindkey "^[[3~" delete-char
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;5C" forward-word
      bindkey "^[[3;5~" kill-word
      bindkey "^H" backward-kill-word
    ''
    + lib.optionalString (config.programs.vscode.enable && config.programs.zoxide.enable) ''
      code() {
        if [ ! -e "''$1" ]; then
          local dir=''$(zoxide query "''$@")
          if [ ''$? -eq 0 ] && [ -n "''$dir" ]; then
            command code "''$dir"
          else
            return 1
          fi
        else
          command code "''$@"
        fi
      }
    '';

    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "zsh-fzf-history-search";
        src = pkgs.zsh-fzf-history-search;
      }
    ];
  };
}
