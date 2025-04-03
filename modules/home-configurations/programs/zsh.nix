{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;

    shellAliases = {
      ls = "eza";
      ll = "ls -al";
      tree = "ls -T";

      grep = "rg";
      adoc = "asciidoctor";
      shutdown = "shutdown -h now";
      ":q" = "exit";
      neofetch = "fastfetch";
      cat = "bat";
      cloc = "tokei";
      url = "open";
      man = "batman";
      diff = "batdiff";

      copy = "xsel --input --clipboard";
      paste = "xsel --output --clipboard";

      ".." = "cd ..";
      "2.." = "cd ../..";
      "3.." = "cd ../../..";
      "4.." = "cd ../../../..";
      "5.." = "cd ../../../../..";
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
      ];
    };

    completionInit = "autoload -Uz compinit && autoload -Uz vcs_info && compinit";
    defaultKeymap = "emacs";

    initExtra = ''
      precmd() { vcs_info }

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

      code() {
        if [ ! -e "$1" ]; then
          local dir=$(zoxide query "$@")
          if [ $? -eq 0 ] && [ -n "$dir" ]; then
            command code "$dir"
          else
            return 1
          fi
        else
          command code "$@"
        fi
      }

      # bash like keybindings (https://www.enlinux.com/bash-keyboard-shortcuts)
      bindkey "^T" transpose-chars
      bindkey "^[[3~" delete-char
      bindkey "^[[1;5D" backward-word
      bindkey "^[[1;5C" forward-word
      bindkey "^[[3;5~" kill-word
      bindkey "^H" backward-kill-word
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
