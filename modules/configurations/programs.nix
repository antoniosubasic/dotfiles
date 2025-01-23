{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    man
    curl
    wget
    unzip
    docker-compose
    libnotify
    sqlite

    google-chrome
  ];

  services = {
    tailscale.enable = true;
    plantuml-server = {
      enable = true;
      listenPort = 9090;
    };
  };

  programs.zsh.enable = true;

  virtualisation = {
    docker.enable = true;
    containerd.enable = true;
  };
}
