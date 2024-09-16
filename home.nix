{ unstable, shmenu }: { pkgs, lib, ... }:
let
  i3status-rust = unstable.i3status-rust.override { withICUCalendar = true; };
  personal = import ./personal.nix;
in
{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      keybindings = lib.mkOptionDefault {
        "Mod4+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
        "Mod4+d" = "exec ${shmenu}/bin/shmenu";
        "Print" = "exec ${pkgs.flameshot}/bin/flameshot gui";
      };
      startup = [{
        always = true;
        command = "${pkgs.networkmanagerapplet}/bin/nm-applet";
      }];
      bars = [
        {
          position = "bottom";
          statusCommand = "${i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
        }
      ];
    };
  };
  programs.git = with personal.git; {
    enable = true;
    userName = name;
    userEmail = email;
    extraConfig = {
      pull.rebase = true;
      core.excludesFile = "${./global-git-ignore}";
    };
  };
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
    ];
  };
  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        icons = "awesome5";
        theme = "modern";
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
            block = "time";
            interval = 1;
            format = "$timestamp.datetime(f:'long', locale:'fa_IR-u-ca-islamic')";
          }
          {
            block = "custom";
            command = "praytimes-kit next --config ${./praytime-config.json}";
            interval = 10;
          }
          {
            block = "cpu";
            click = [{
              button = "left";
              cmd = "gnome-system-monitor";
            }];
          }
          {
            block = "temperature";
          }
          {
            block = "battery";
            format = " $icon $percentage {$time |}";
            device = "DisplayDevice";
            driver = "upower";
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

  home.file = {
    ".config/VSCodium/User/settings.json".source = ./vscode.json;
  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "23.05";
}
