{
  config,
  pkgs,
  cosmicLib,
  ...
}:
let
  keyboard = {
    repeat_delay = 301;
    repeat_rate = 25;
  };
  touchpad = {
    scroll_factor = 3.25;
    speed = 0.8;
  };
in
{
  wayland.desktopManager.cosmic = {
    enable = true;
    resetFiles = false;
  };
  wayland.desktopManager.cosmic.applets.time.settings = {
    first_day_of_week = 6;
    military_time = true;
    show_seconds = true;
    show_weekday = true;
  };
  wayland.desktopManager.cosmic.compositor = {
    active_hint = true;
    autotile = true;
    xkb_config = {
      layout = "us";
      model = "pc104";
      variant = "";
      options = cosmicLib.cosmic.mkRON "optional" "eurosign=e,caps=escape";
      repeat_delay = keyboard.repeat_delay;
      repeat_rate = keyboard.repeat_rate;
      rules = "";
    };
    input_touchpad = {
      state = cosmicLib.cosmic.mkRON "enum" "Enabled";
      acceleration = cosmicLib.cosmic.mkRon "optional" {
        profile = cosmicLib.cosmic.mkRON "optional" null;
        speed = touchpad.speed;
      };
      click_method = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRon "enum" "Clickfinger");
      scroll_config = cosmicLib.cosmic.mkRON "optional" {
        method = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRon "enum" "TwoFinger");
        natural_scroll = cosmicLib.cosmic.mkRON "optional" true;
        scroll_button = cosmicLib.cosmic.mkRON "optional" null;
        scroll_factor = cosmicLib.cosmic.mkRON "optional" touchpad.scroll_factor;
      };
      tap_config = cosmicLib.cosmic.mkRON "optional" {
        enabled = true;
        drag_lock = false;
        drag = true;
        button_map = cosmicLib.cosmic.mkRON "optional" (cosmicLib.cosmic.mkRON "enum" "LeftRightMiddle");
      };
    };
  };
  wayland.desktopManager.cosmic.panels = [
    {
      anchor = cosmicLib.cosmic.mkRON "enum" "Top";
      anchor_gap = false;
      autohide = cosmicLib.cosmic.mkRON "optional" null;
      background = cosmicLib.cosmic.mkRON "enum" "Dark";
      expand_to_edges = true;
      margin = 0;
      name = "Panel";
      opacity = 1.0;
      output = cosmicLib.cosmic.mkRON "enum" "All";
      plugins_center = cosmicLib.cosmic.mkRON "optional" [
        "com.system76.CosmicAppletTime"
      ];
      plugins_wings = cosmicLib.cosmic.mkRON "optional" (
        cosmicLib.cosmic.mkRON "tuple" [
          [
            "com.system76.CosmicPanelWorkspacesButton"
          ]
          [
            "com.system76.CosmicAppletInputSources"
            "com.system76.CosmicAppletStatusArea"
            "com.system76.CosmicAppletTiling"
            "com.system76.CosmicAppletAudio"
            "com.system76.CosmicAppletNetwork"
            "com.system76.CosmicAppletBattery"
            "com.system76.CosmicAppletNotifications"
            "com.system76.CosmicAppletBluetooth"
            "com.system76.CosmicAppletPower"
          ]
        ]
      );
      size = cosmicLib.cosmic.mkRON "enum" "XS";
    }

  ];
  wayland.desktopManager.cosmic.appearance.theme.dark = {
    gaps = cosmicLib.cosmic.mkRON "tuple" [
      0
      2
    ];
    active_hint = 1;
    corner_radii = {
      radius_0 = cosmicLib.cosmic.mkRON "tuple" [
        0.0
        0.0
        0.0
        0.0
      ];
      radius_xs = cosmicLib.cosmic.mkRON "tuple" [
        2.0
        2.0
        2.0
        2.0
      ];
      radius_s = cosmicLib.cosmic.mkRON "tuple" [
        2.0
        2.0
        2.0
        2.0
      ];
      radius_m = cosmicLib.cosmic.mkRON "tuple" [
        2.0
        2.0
        2.0
        2.0
      ];
      radius_l = cosmicLib.cosmic.mkRON "tuple" [
        2.0
        2.0
        2.0
        2.0
      ];
      radius_xl = cosmicLib.cosmic.mkRON "tuple" [
        2.0
        2.0
        2.0
        2.0
      ];
    };
  };
  wayland.desktopManager.cosmic.shortcuts = [
    {
      action = cosmicLib.cosmic.mkRON "enum" {
        value = [ "ghostty --gtk-single-instance=true" ];
        variant = "Spawn";
      };
      description = cosmicLib.cosmic.mkRON "optional" "Open ghostty";
      key = "Super+t";
    }
    {
      action = cosmicLib.cosmic.mkRON "enum" {
        value = [ "ghostty --gtk-single-instance=true -e 'ringboard-tui'" ];
        variant = "Spawn";
      };
      description = cosmicLib.cosmic.mkRON "optional" "clip manager";
      key = "Super+v";
    }
  ];
  programs.cosmic-files.settings = {
    enable = true;
    desktop = {
      show_content = false;
      show_mounted_drives = false;
      show_trash = false;
    };
  };

}
