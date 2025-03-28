{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    man
    curl
    wget
    unzip
    docker-compose
    libnotify
    jq
    xsel
    ripgrep
    eza
  ];

  services = {
    tailscale.enable = true;
    plantuml-server = {
      enable = true;
      listenPort = 9090;
    };
  };

  programs = {
    zsh.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };

  virtualisation = {
    docker.enable = true;
    containerd.enable = true;
  };
}
