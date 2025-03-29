{
  services.dropbox.enable = true;
  home.file.".config/autostart/dropbox.desktop".text = ''
    [Desktop Entry]
    Name=Dropbox
    GenericName=File Synchronizer
    Comment=Sync your files across computers and to the we
    Exec=dropbox start -i
    Terminal=false
    Type=Application
    Icon=dropbox
    Categories=Network;FileTransfer;
    Keywords=file;synchronization;sharing;collaboration;cloud;storage;backup;
    StartupNotify=false
  '';
}
