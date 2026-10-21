{
  config,
  lib,
  pkgs,
  ...
}:
let
  battery = config.hyprlandConfig.battery;
  # compact one-line style shared by the system notifiers below
  systemStyle = {
    format = "<b>%s</b>  %b";
    background = "#1c3d5a";
    frame_color = "#4fa3e0";
    timeout = 3;
  };
in
{
  environment.systemPackages = [ pkgs.libnotify ];
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "(30,30)";
        origin = "top-right";
        follow = "keyboard"; # show on the focused monitor, not the first output (e.g. headless v1)
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
      # Sections are emitted alphabetically and later rules win, so these must
      # sort after urgency_* or the urgency background overrides them.
      z_bluetooth = systemStyle // { appname = "Bluetooth"; };
      z_network = systemStyle // { appname = "Network"; };
      z_battery = systemStyle // { appname = "Battery"; };
    };
  };
  home-manager.sharedModules = [
    ({ pkgs, ... }:
      let
        # gdbus prints each PropertiesChanged signal on one line, e.g.
        # /org/bluez/hci0/dev_AA_BB_..: ...PropertiesChanged ('org.bluez.Device1', {'Connected': <true>}, @as [])
        bluetoothNotify = pkgs.writeShellApplication {
          name = "bluetooth-notify";
          runtimeInputs = [ pkgs.glib pkgs.bluez pkgs.libnotify pkgs.gnused ];
          text = ''
            re="dev_([0-9A-F_]+): .*'org\.bluez\.Device1', \{[^}]*'Connected': <(true|false)>"
            gdbus monitor --system --dest org.bluez | while read -r line; do
              [[ $line =~ $re ]] || continue
              mac=''${BASH_REMATCH[1]//_/:}
              name=$(bluetoothctl info "$mac" | sed -n 's/^\s*Alias: //p' || true)
              if [[ ''${BASH_REMATCH[2]} == true ]]; then
                notify-send -a Bluetooth -i bluetooth-active -h string:x-dunst-stack-tag:bluetooth "Connected" "''${name:-$mac}"
              else
                notify-send -a Bluetooth -i bluetooth-disabled -h string:x-dunst-stack-tag:bluetooth "Disconnected" "''${name:-$mac}"
              fi
            done
          '';
        };
        networkNotify = pkgs.writeShellApplication {
          name = "network-notify";
          runtimeInputs = [ pkgs.networkmanager pkgs.libnotify ];
          text = ''
            nmcli monitor | while read -r line; do
              case $line in
                *" is now the primary connection")
                  conn=''${line% is now the primary connection}
                  notify-send -a Network -i network-wired -h string:x-dunst-stack-tag:network "Connected" "''${conn//\'/}"
                  ;;
                "There's no primary connection")
                  notify-send -a Network -i network-offline -h string:x-dunst-stack-tag:network "Disconnected" "No network connection"
                  ;;
              esac
            done
          '';
        };
        # Re-checks on every power_supply udev event (plug/unplug), and every 30s for level changes.
        batteryNotify = pkgs.writeShellApplication {
          name = "battery-notify";
          runtimeInputs = [ pkgs.systemd pkgs.libnotify ];
          text = ''
            bat=$(find /sys/class/power_supply/ -maxdepth 1 -name 'BAT*' | head -n1)
            [[ -n $bat ]] || exit 0

            # Plugged in != charging (e.g. "Not charging" at a charge limit), so plug
            # state comes from the mains adapter rather than the battery status.
            ac_online() {
              local s
              for s in /sys/class/power_supply/*; do
                [[ $(<"$s/type") == Mains && $(<"$s/online") == 1 ]] && return 0
              done
              return 1
            }

            notify() {
              notify-send -a Battery -i "$1" -h string:x-dunst-stack-tag:battery "$2" "$3"
            }

            prev_plugged=$(ac_online && echo 1 || echo 0)
            prev_status=$(<"$bat/status")
            warned=""
            check() {
              cap=$(<"$bat/capacity")
              status=$(<"$bat/status")
              plugged=$(ac_online && echo 1 || echo 0)
              if [[ $plugged != "$prev_plugged" ]]; then
                if [[ $plugged == 1 ]]; then
                  notify ac-adapter "Plugged in" "$cap%"
                else
                  notify battery-good "Unplugged" "$cap%"
                fi
                prev_plugged=$plugged
              fi
              if [[ $status != "$prev_status" ]]; then
                [[ $status == Full ]] && notify battery-full-charged "Fully charged" "$cap%"
                prev_status=$status
              fi
              if [[ $plugged == 0 ]]; then
                if (( cap <= 10 )) && [[ $warned != critical ]]; then
                  notify battery-caution "Battery critical" "$cap%"
                  warned=critical
                elif (( cap <= 20 )) && [[ -z $warned ]]; then
                  notify battery-low "Battery low" "$cap%"
                  warned=low
                fi
              else
                warned=""
              fi
            }

            while :; do
              check
              rc=0
              read -r -t 30 _ || rc=$?
              # rc > 128 is the timeout; anything else means udevadm died
              (( rc == 0 || rc > 128 )) || exit 1
            done < <(udevadm monitor --udev --subsystem-match=power_supply)
          '';
        };
        mkNotifyService = description: exe: {
          Unit = {
            Description = description;
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          Service = {
            ExecStart = exe;
            Restart = "on-failure";
            RestartSec = 5;
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      in
      {
        systemd.user.services = {
          bluetooth-notify = mkNotifyService "Bluetooth connection notifications" (lib.getExe bluetoothNotify);
          network-notify = mkNotifyService "Network connection notifications" (lib.getExe networkNotify);
        } // lib.optionalAttrs battery {
          battery-notify = mkNotifyService "Battery notifications" (lib.getExe batteryNotify);
        };
      })
  ];
}
