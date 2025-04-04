{
  lib,
  utils,
  pkgs,
  ...
}:

lib.mkIf (utils.hasTag "personal") {
  home = {
    packages = [ pkgs.keepassxc ];
    file = {
      ".config/autostart/keepassxc.desktop".text = ''
        [Desktop Entry]
        Name=KeePassXC
        GenericName=Password Manager
        Comment=Manage your passwords
        Exec=keepassxc --minimized
        Terminal=false
        Type=Application
        Icon=keepassxc
        Categories=Security;PasswordManager;
        Keywords=security;password;manager;keepassxc;
        StartupNotify=false
      '';
    };
  };
}
