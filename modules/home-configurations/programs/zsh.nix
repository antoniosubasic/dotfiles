{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;

    shellAliases = {
      ls = "eza --git --icons --time-style=+\"%d.%m.%Y %H:%M:%S\" --color=always";
      ll = "ls -al";
      tree = "ls -T";

      grep = "rg";
      adoc = "asciidoctor";
      shutdown = "shutdown -h now";
      ":q" = "exit";
      neofetch = "fastfetch";
      cat = "bat";

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
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

      setopt PROMPT_SUBST
      PROMPT='%F{blue}%~%f''${vcs_info_msg_0_}%(?.%F{green}.%F{red}) ❯%f '

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
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "master";
          sha256 = "1brljd9744wg8p9v3q39kdys33jb03d27pd0apbg1cz0a2r1wqqi";
        };
      }
      {
        name = "zsh-fzf-history-search";
        src = pkgs.fetchFromGitHub {
          owner = "joshskidmore";
          repo = "zsh-fzf-history-search";
          rev = "master";
          sha256 = "1dm1asa4ff5r42nadmj0s6hgyk1ljrckw7val8fz2n0892b8h2mm";
        };
      }
    ];
  };
}
