{
  pkgs,
  hostname,
  username,
  config,
  ...
}:

{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      theme = pkgs.sleek-grub-theme.override {
        withBanner = "Hello ${username}";
        withStyle = "dark";
      };
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

  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
      powerManagement.enable = true;
    };
    nvidia-container-toolkit.enable = true;
  };

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
      videoDrivers = [ "nvidia" ];
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
  };

  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
        glib
        util-linux
      ];
    };
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 5 --keep-since 3d";
      };
      flake = "/home/${username}/.dotfiles";
    };
  };

  environment.variables = {
    LD_LIBRARY_PATH = "/run/current-system/sw/share/nix-ld/lib";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
