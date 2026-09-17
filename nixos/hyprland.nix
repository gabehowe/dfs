{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.hyprlandConfig = {
    battery = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to use battery info.";
    };
  };
  config = {
    systemd.services.display-manager.path = [ pkgs.gnome-session ];
    environment.systemPackages = [
      pkgs.hyprlauncher
      pkgs.kitty
      pkgs.hyprcursor
      pkgs.hyprlock
      pkgs.hyprpolkitagent
      pkgs.wiremix
      pkgs.playerctl
      pkgs.kdePackages.dolphin
      pkgs.slurp
      pkgs.grim
      pkgs.libnotify
    ];
    services.dunst = {
      enable = true;
      settings = {
        global = {
          width = 300;
          height = 300;
          offset = "(30,30)";
          origin = "top-right";
          transparency = 10;
          frame_color = "#eceff1";
          frame_width = 1;
          font = "Droid Sans 9";
          gap_size = 2;
          corner_radius = 2;
          timeout = 5;
        };
        urgency_normal = {
          background = "#af005f";
        };
        urgency_critical = {
          background = "#ffaf00";
        };

      };
    };
    programs.hyprland = {
      enable = true;
      withUWSM = true; # recommended for most users
      xwayland.enable = true; # Xwayland can be disabled.
    };
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    home-manager.sharedModules = [
      {
        services.hypridle = {
          enable = true;
          settings = {
            general = {
              after_sleep_cmd = "hyprctl dispatch dpms on";
              before_sleep_cmd = "loginctl lock-session";
              lock_cmd = "hyprlock";
            };
          };
        };
        home.pointerCursor = {
          enable = true;
          gtk.enable = true;
          x11.enable = true;
          package = pkgs.vanilla-dmz;
          hyprcursor = {
            enable = true;
            size = 16;
          };
          name = "Vanilla-DMZ";
          size = 16;
        };
      }
      {
        wayland.windowManager.hyprland = {
          enable = true;

          # New in PR #9307 — defaults to "lua" for stateVersion 26.05+,
          # explicit here for clarity
          configType = "lua";

          # exec-once is broken in settings (generates invalid hl.exec-once).
          # Use extraLuaConfig with hl.on("hyprland.start", ...) instead.
          # See: https://github.com/nix-community/home-manager/issues/9341

          extraConfig = builtins.readFile ./hyprland/hyprland.lua;
        };
      }
      {
        # home.nix or wherever your home-manager config lives
        programs.hyprlock = {
          enable = true;

          settings = {
            general = {
              hide_cursor = false;
            };

            animations = {
              enabled = true;
              bezier = "linear, 1, 1, 0, 0";
              animation = [
                "fadeIn, 1, 1, linear"
                "fadeOut, 1, 1, linear"
                "inputFieldDots, 1, .25, linear"
              ];
            };

            background = [
              {
                monitor = "";
                path = "screenshot";
                blur_passes = 7;
              }
            ];

            input-field = [
              {
                monitor = "";
                size = "15%, 3%";
                outline_thickness = 3;
                inner_color = "rgba(11111166)";
                outer_color = "rgba(222222ee)";
                check_color = "rgba(00ff99ee) rgba(ff6633ee) 120deg";
                fail_color = "rgba(ff6633ee) rgba(ff0066ee) 40deg";
                font_color = "rgb(143, 143, 143)";
                fade_on_empty = true;
                rounding = 3;
                font_family = "Monospace";
                placeholder_text = "Input password...";
                fail_text = "retry";
                dots_spacing = 0.3;
                position = "0, -20";
                halign = "center";
                valign = "center";
              }
            ];

            label = [
              # TIME
              {
                monitor = "";
                text = "$TIME";
                font_size = 50;
                font_family = "Monospace";
                position = "30, -30";
                halign = "left";
                valign = "top";
              }
              # DATE
              {
                monitor = "";
                text = ''cmd[update:1000] date +"%A, %d %B %Y"'';
                font_size = 25;
                font_family = "Monospace";
                position = "30, -100";
                halign = "left";
                valign = "top";
              }
            ];
          };
        };
        wayland.windowManager.hyprland = {
          systemd.enable = false;
          enable = true;
          configType = "lua";
          systemd.variables = [ "--all" ];
        };
        programs.waybar = {
          enable = true;
          style = ''
                      @define-color text #fcfcfc;
            @define-color gray #000000;
            @define-color green shade(#5faf00, 1.2);
            @define-color accent shade(#af005f, 1.2);
            @define-color background #2a2a2a;
            @define-color yellow shade(#ffaf00, 1.2);

            window {
                font-family: "Ubuntu Nerd Font";
            }
            window#waybar {
                background: none;
            }
            .module {
                background-color: @background;
                padding: 2px 5px;
                margin: 0 2px;
                border-radius: 5px;
                color: @text;
            }
            #battery.charging {
            	color: @green;
            }
            #wireplumber.muted {
            	color: @accent;
            }
            #bluetooth:active {
                background-color:blue;
            }
            #workspaces {
                background: none;
                padding: 0px;
            }
            #workspaces button{
                background: @background;
                margin:0 1px;
                padding: 0px;
                min-width:  25px;
                min-height: 25px;
                font-size: 14pt;
            }
            #workspaces button.visible {
                color: @accent;
            }

            #power-profiles-daemon  {
            	padding-left: 0px;
            	margin-left: -7px;
            	color: @yellow;
            }
            #power-profiles-daemon.performance {
            	color: @accent;
            }
            #power-profiles-daemon.power-saver {
            	color: @green;
            }
          '';
          settings = {
            mainBar = {
              modules-left = [ "hyprland/workspaces" ];
              modules-right =
                if config.hyprlandConfig.battery then
                  [
                    "bluetooth"
                    "clock"
                    "wireplumber"
                    "battery"
                    "power-profiles-daemon"
                  ]
                else
                  [
                    "bluetooth"
                    "clock"
                    "wireplumber"
                  ];
              reload_style_on_change = true;
              "clock" = {
                interval = 1;
                format = "{:%A, %b %d %H:%M:%S}";
              };
              "hyprland/workspaces" = {
                format = "{icon}";
                on-click = "activate";
                show-special = true;
                special-visible-only = true;
                format-icons = {
                  "1" = "󰇊";
                  "2" = "󰇋";
                  "3" = "󰇌";
                  "4" = "󰇍";
                  "5" = "󰇎";
                  "6" = "󰇏";
                  "magic" = "";
                };
                sort-by-id = true;
              };
              "power-profiles-daemon" = {
                format = "{icon}";
                tooltip-format = "{profile}";
                tooltip = "true";
                format-icons = {
                  default = "D";
                  performance = "↘";
                  balanced = "→";
                  power-saver = "↗";
                };
              };
              "bluetooth" = {
                format = " {status}";
                on-click = "ghostty --class='tui.bluetui' -e bluetui";
                format-connected = " {device_alias}";
                format-connected-battery = " {device_alias} {device_battery_percentage}%";
                format-device-preference = [
                  "device1"
                  "device2"
                ];
                tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
                tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
                tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
                tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
              };
              "wireplumber" = {
                format = "{node_name} {volume:>3}% {icon}";
                format-muted = "{node_name} {volume:>3}% ";
                on-click = "ghostty --class='tui.wiremix' -e wiremix";
                format-icons = [
                  ""
                  ""
                  ""
                ];
              };
              "battery" = {
                interval = 20;
                format = "{capacity}% {icon}";
                format-icons = {
                  default = [
                    "󰂎"
                    "󰁺"
                    "󰁻"
                    "󰁼"
                    "󰁽"
                    "󰁾"
                    "󰁿"
                    "󰂀"
                    "󰂁"
                    "󰂂"
                    "󰁹"
                  ];
                  charging = [
                    "󰢟"
                    "󰢜"
                    "󰂆"
                    "󰂇"
                    "󰂈"
                    "󰢝"
                    "󰂉"
                    "󰢞"
                    "󰂊"
                    "󰂋"
                    "󰂅"
                  ];
                };
              };
            };
          };
        };
        gtk = {
          enable = true;
          colorScheme = "dark";
        };
      }
    ];
  };
}
