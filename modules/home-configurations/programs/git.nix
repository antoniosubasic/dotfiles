{ utilities, ... }:

{
  programs.git = {
    enable = utilities.hasTags [
      "shell"
      "dev"
    ];
    userName = "Antonio Subašić";
    userEmail = "antonio.subasic.public@gmail.com";
    aliases = {
      cm = "commit -m";
      cp = "!f() { git clone git@github.com:$(git config user.github)/$1.git \${2:-$1}; }; f";
      transpose-ssh = "!f() { git remote set-url origin $(git remote get-url origin | sed 's|https://github.com/|git@github.com:|'); }; f";
      transpose-https = "!f() { git remote set-url origin $(git remote get-url origin | sed 's|git@github.com:|https://github.com/|'); }; f";
      tree = "log --graph --oneline --decorate --all";
      url = "!f() { git remote get-url origin | sed 's|git@github.com:|https://github.com/|'; }; f";
    };
    extraConfig = {
      user.github = "antoniosubasic";
      init.defaultBranch = "main";
      help.autocorrect = 10;
      url."git@github.com".insteadOf = "gh:";
      diff.algorithm = "histogram";
      status.submoduleSummary = true;
      core = {
        autocrlf = false;
        editor = "nvim";
      };
      log.date = "iso";
      pull.ff = "only";
      push.autoSetupRemote = true;
      transfer.fsckobjects = true;
      fetch.fsckobjects = true;
      receive.fsckObjects = true;
    };
    ignores = [
      "bin/"
      "obj/"
      "target/"
      "node_modules/"
      ".env"
    ];
  };
}
