{ pkgs, lib, ... }: 
let i3status-fork = import ./i3status-fork.nix (import <unstable> {}); in
{
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        keybindings = lib.mkOptionDefault {
          "Mod4+Return" = "exec ${pkgs.konsole}/bin/konsole";
        };
        bars = [
          {
            position = "bottom";
            statusCommand = "${i3status-fork}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
          }
        ];
      };
    };
    programs.i3status-rust = {
      enable = true;
      bars = {
        bottom = {
          blocks = [
            {
              block = "time";
              interval = 1;
              format = "$timestamp.datetime(f:'%F %T')";
            }
            {
              block = "time";
              interval = 1;
              format = "$timestamp.datetime(f:'full', locale:'fa_IR-u-ca-persian')";
              click = [{
                button = "left";
                cmd = "firefox --new-window https://time.ir";
              }];
            }
            {
              block = "cpu";
              click = [{
                button = "left";
                cmd = "gnome-system-monitor";
              }];
            }
            {
              block = "disk_space";
            }
            {
              block = "net";
              format = "$icon $ip ^icon_net_down $speed_down.eng(prefix:K) ^icon_net_up $speed_up.eng(prefix:K)";
              click = [{
                button = "left";
                cmd = "nm-connection-editor";
              }];
            }
            {
              block = "sound";
              click = [{
                button = "left";
                cmd = "pavucontrol";
              }];
            }
            {
              block = "custom";
              command = "xkb-switch";
              interval = 1;
            }
          ];
        };
      };
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.05";
  }