{ pkgs, username, hostname, flakePath, ... }:

{
  # https://discourse.nixos.org/t/nixos-upgrade-service-doesnt-work-with-flakes-because-update-input-flag-is-deprecated/47054/2

  systemd = {
    services.nixos-upgrade = {
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        WorkingDirectory = flakePath;
        Environment = "HOME=/home/${username}";
      };
      script = ''
        #!/bin/sh
        ${pkgs.su}/bin/su ${username} -c '${pkgs.nix}/bin/nix flake update --commit-lock-file --flake "${flakePath}" && ${pkgs.git}/bin/git push'
        ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake "${flakePath}#${hostname}"
      '';
      path = with pkgs; [ git openssh ];
    };

    timers.nixos-upgrade = {
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
        Unit = "nixos-upgrade.service";
        RandomizedDelaySec = "45min";
      };
    };
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;
}
