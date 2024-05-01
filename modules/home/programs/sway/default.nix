{ pkgs, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    config = rec {
      menu = "rofi -show run";
      terminal = "kitty";
      modifier = "Mod4";
      startup = [
        { command = "swaymsg 'workspace 1; exec kitty'"; }
        { command = "swaymsg 'workspace 2; exec firefox'"; }
      ];
      bars = [ ];
      window.titlebar = false;
      keybindings = pkgs.lib.mkOptionDefault {
        "${modifier}+p" = "exec ${menu}";
        "${modifier}+Shift+r" = "reload";
        "${modifier}+Shift+c" = "kill";
        "${modifier}+Shift+q" = "exit";
        "${modifier}+Shift+a" = "exec screenshot area";
        "${modifier}+Shift+s" = "exec screenshot";
        "Alt+Shift+l" = "exec ${pkgs.swaylock}/bin/swaylock";
        "XF86ScreenSaver" = "output 'eDP-1' toggle";
        "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86MonBrightnessUp" = "exec sudo ${pkgs.light}/bin/light -A 10";
        "XF86MonBrightnessDown" = "exec sudo ${pkgs.light}/bin/light -U 10";
        "Mod1+c" = "exec rofi -show calc";
      };
      input = {
        "*" = {
          xkb_layout = "us,bg";
          xkb_options = "grp:win_space_toggle";
          xkb_variant = ",phonetic";
        };
      };
    };
    swaynag = {
      enable = true;
    };
  };
  home.packages = with pkgs; [
    audacity
    gimp
    grim
    imv
    libnotify
    libreoffice-qt
    mako
    mpv
    mupdf
    pavucontrol
    scripts
    slurp
    wl-clipboard
    xdg-user-dirs
    xdg-utils
    xwayland
  ];
}
