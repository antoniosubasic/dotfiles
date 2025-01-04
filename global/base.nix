{ config, pkgs, username, hostname, ... }:

let
  grubTheme = pkgs.fetchFromGitHub {
    owner = "sandesh236";
    repo = "sleek--themes";
    rev = "0c47e645ccc2d72aa165e9d994f9d09f58de9f6d";
    sha256 = "1q5583hvfjv19g503whl5mq4vqw2ci4f6w1z8pya23bw4h4ki2qz";
  };
in
{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      theme = "${grubTheme}/Sleek theme-dark/sleek";
    };
  };

  networking = {
    networkmanager.enable = true;
    hostName = hostname;
  };

  time = {
    timeZone = "Europe/Vienna";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_AT.UTF-8";
      LC_IDENTIFICATION = "de_AT.UTF-8";
      LC_MEASUREMENT = "de_AT.UTF-8";
      LC_MONETARY = "de_AT.UTF-8";
      LC_NAME = "de_AT.UTF-8";
      LC_NUMERIC = "de_AT.UTF-8";
      LC_PAPER = "de_AT.UTF-8";
      LC_TELEPHONE = "de_AT.UTF-8";
      LC_TIME = "de_AT.UTF-8";
      LC_COLLATE = "de_AT.UTF-8";
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  hardware.bluetooth.enable = true;
  security = {
    rtkit.enable = true;
    pam.services = {
      login.fprintAuth = false;
    };
  };

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "at";
        variant = "";
      };
    };

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    fprintd.enable = true;

    printing.enable = true;

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

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];

    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
