{ pkgs, ... }:
let
  uwsmStart = pkgs.writeText ''
    if uwsm check may-start; then
    	exec systemd-cat -t uwsm_start uwsm start hyprland-hm
    fi
  '';

  execHypr = pkgs.writeScript ''
    tuigreet --remember --asterisks --container-padding 2 --time \
      --time-format '%I:%M %p | %a • %h | %F' --cmd "${uwsmStart}"
  '';
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = execHypr;
        user = "greeter";
      };
    };
  };

  environment.systemPackages = with pkgs; [ greetd.tuigreet ];

  # this is a life saver.
  # literally no documentation about this anywhere.
  # might be good to write about this...
  # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";

}