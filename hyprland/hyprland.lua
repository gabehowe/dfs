-- settings.locals
local fileManager = "dolphin"
local mainMod = "SUPER"
local menu = "hyprlauncher -t"
local terminal = "ghostty"
local waybar_height = 24

-- settings.curve
hl.curve("easeOutQuint", {
  ["points"] = {
    {
      0.23,
      1
    },
    {
      0.32,
      1
    }
  },
  ["type"] = "bezier"
})
hl.curve("easeInOutCubic", {
  ["points"] = {
    {
      0.65,
      0.05
    },
    {
      0.36,
      1
    }
  },
  ["type"] = "bezier"
})
hl.curve("linear", {
  ["points"] = {
    {
      0,
      0
    },
    {
      1,
      1
    }
  },
  ["type"] = "bezier"
})
hl.curve("almostLinear", {
  ["points"] = {
    {
      0.5,
      0.5
    },
    {
      0.75,
      1
    }
  },
  ["type"] = "bezier"
})
hl.curve("quick", {
  ["points"] = {
    {
      0.15,
      0
    },
    {
      0.1,
      1
    }
  },
  ["type"] = "bezier"
})
hl.curve("easy", {
  ["dampening"] = 50,
  ["mass"] = 1,
  ["stiffness"] = 600,
  ["type"] = "spring"
})

-- settings.animation
-- hl.animation({ bezier="default",  enabled=true,  leaf="global",  speed=100})
-- hl.animation({ bezier="easeOutQuint",  enabled=true,  leaf="border",  speed=3})
hl.animation({ enabled=true,  leaf="windows",  speed=0.1,  spring="easy"})
hl.animation({ enabled=true,  leaf="windowsIn",  speed=0.5,  spring="easy",  style="popin 87%"})
hl.animation({ bezier="linear",  enabled=true,  leaf="windowsOut",  speed=0.1,  style="popin 87%"})
-- hl.animation({ bezier="almostLinear",  enabled=true,  leaf="fadeIn",  speed=1.73})
-- hl.animation({ bezier="almostLinear",  enabled=true,  leaf="fadeOut",  speed=1.46})
hl.animation({ bezier="quick",  enabled=true,  leaf="fade",  speed=3.03})
hl.animation({ bezier="easeOutQuint",  enabled=true,  leaf="layers",  speed=3.81})
hl.animation({ bezier="easeOutQuint",  enabled=true,  leaf="layersIn",  speed=4,  style="fade"})
hl.animation({ bezier="easeInOutCubic",  enabled=true,  leaf="layersOut",  speed=1.5,  style="fade"})
hl.animation({ bezier="almostLinear",  enabled=true,  leaf="fadeLayersIn",  speed=1.79})
hl.animation({ bezier="almostLinear",  enabled=true,  leaf="fadeLayersOut",  speed=1.39})
hl.animation({ bezier="almostLinear",  enabled=true,  leaf="workspaces",  speed=1.94,  style="fade"})
hl.animation({ bezier="easeInOutCubic",  enabled=true,  leaf="workspacesIn",  speed=0.65,  style="slidefade"})
hl.animation({ bezier="easeInOutCubic",  enabled=true,  leaf="workspacesOut",  speed=0.65,  style="slidefade"})
hl.animation({ bezier="quick",  enabled=true,  leaf="zoomFactor",  speed=1})

-- settings.bind
hl.bind("PRINT", (hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy')))
hl.bind((mainMod .. " + Escape"), (hl.dsp.exec_cmd("hyprlock")))
hl.bind((mainMod .. " + T"), (hl.dsp.exec_cmd(terminal)))
hl.bind((mainMod .. " + q"), (hl.dsp.window.close()))
hl.bind((mainMod .. " + SHIFT + Escape"), (hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")))
hl.bind((mainMod .. " + E"), (hl.dsp.exec_cmd(fileManager)))
hl.bind((mainMod .. " + G"), (hl.dsp.window.float({ action = "toggle" })))
hl.bind((mainMod .. " + SUPER_L"), (hl.dsp.exec_cmd(menu)))
hl.bind((mainMod .. " + P"), (hl.dsp.window.pseudo()))
hl.bind((mainMod .. " + O"), (hl.dsp.layout("togglesplit")))
hl.bind((mainMod .. " + h"), (hl.dsp.focus({ direction = "left" })))
hl.bind((mainMod .. " + l"), (hl.dsp.focus({ direction = "right" })))
hl.bind((mainMod .. " + k"), (hl.dsp.focus({ direction = "up" })))
hl.bind((mainMod .. " + j"), (hl.dsp.focus({ direction = "down" })))
hl.bind((mainMod .. "+ SHIFT + h"), (hl.dsp.window.move({ direction = "left" })))
hl.bind((mainMod .. "+ SHIFT + l"), (hl.dsp.window.move({ direction = "right" })))
hl.bind((mainMod .. "+ SHIFT + k"), (hl.dsp.window.move({ direction = "up" })))
hl.bind((mainMod .. "+ SHIFT + j"), (hl.dsp.window.move({ direction = "down" })))
hl.bind((mainMod .. " + S"), (hl.dsp.workspace.toggle_special("magic")))
hl.bind((mainMod .. " + SHIFT + S"), (hl.dsp.window.move({ workspace = "special:magic" })))
hl.bind((mainMod .. " + mouse_down"), (hl.dsp.focus({ workspace = "e+1" })))
hl.bind((mainMod .. " + mouse_up"), (hl.dsp.focus({ workspace = "e-1" })))
hl.bind((mainMod .. " + mouse:272"), (hl.dsp.window.drag()), {
  ["mouse"] = true
})
hl.bind((mainMod .. " + mouse:273"), (hl.dsp.window.resize()), {
  ["mouse"] = true
})
hl.bind("XF86AudioNext", (hl.dsp.exec_cmd("playerctl next")))
hl.bind("XF86AudioRaiseVolume", (hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+")), {
  ["locked"] = true,
  ["repeating"] = true
})
hl.bind("XF86AudioLowerVolume", (hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")), {
  ["locked"] = true,
  ["repeating"] = true
})
hl.bind("XF86AudioMute", (hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")), {
  ["locked"] = true,
  ["repeating"] = true
})
hl.bind("XF86AudioMicMute", (hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")), {
  ["locked"] = true,
  ["repeating"] = true
})
hl.bind("XF86MonBrightnessUp", (hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+")), {
  ["locked"] = true,
  ["repeating"] = true
})
hl.bind("XF86MonBrightnessDown", (hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-")), {
  ["locked"] = true,
  ["repeating"] = true
})
hl.bind("XF86AudioNext", (hl.dsp.exec_cmd("playerctl next")), {
  ["locked"] = true
})
hl.bind("XF86AudioPause", (hl.dsp.exec_cmd("playerctl play-pause")), {
  ["locked"] = true
})
hl.bind("XF86AudioPlay", (hl.dsp.exec_cmd("playerctl play-pause")), {
  ["locked"] = true
})
hl.bind("XF86AudioPrev", (hl.dsp.exec_cmd("playerctl previous")), {
  ["locked"] = true
})
hl.bind((mainMod .. " + 1"), (hl.dsp.focus({ workspace = 1 })))
hl.bind((mainMod .. " + SHIFT + 1"), (hl.dsp.window.move({ workspace = 1 })))
hl.bind((mainMod .. " + 2"), (hl.dsp.focus({ workspace = 2 })))
hl.bind((mainMod .. " + SHIFT + 2"), (hl.dsp.window.move({ workspace = 2 })))
hl.bind((mainMod .. " + 3"), (hl.dsp.focus({ workspace = 3 })))
hl.bind((mainMod .. " + SHIFT + 3"), (hl.dsp.window.move({ workspace = 3 })))
hl.bind((mainMod .. " + 4"), (hl.dsp.focus({ workspace = 4 })))
hl.bind((mainMod .. " + SHIFT + 4"), (hl.dsp.window.move({ workspace = 4 })))
hl.bind((mainMod .. " + 5"), (hl.dsp.focus({ workspace = 5 })))
hl.bind((mainMod .. " + SHIFT + 5"), (hl.dsp.window.move({ workspace = 5 })))
hl.bind((mainMod .. " + 6"), (hl.dsp.focus({ workspace = 6 })))
hl.bind((mainMod .. " + SHIFT + 6"), (hl.dsp.window.move({ workspace = 6 })))
hl.bind((mainMod .. " + 7"), (hl.dsp.focus({ workspace = 7 })))
hl.bind((mainMod .. " + SHIFT + 7"), (hl.dsp.window.move({ workspace = 7 })))
hl.bind((mainMod .. " + 8"), (hl.dsp.focus({ workspace = 8 })))
hl.bind((mainMod .. " + SHIFT + 8"), (hl.dsp.window.move({ workspace = 8 })))
hl.bind((mainMod .. " + 9"), (hl.dsp.focus({ workspace = 9 })))
hl.bind((mainMod .. " + SHIFT + 9"), (hl.dsp.window.move({ workspace = 9 })))
hl.bind((mainMod .. " + 0"), (hl.dsp.focus({ workspace = 10 })))
hl.bind((mainMod .. " + SHIFT + 0"), (hl.dsp.window.move({ workspace = 10 })))

-- settings.config
hl.config({
  ["animations"] = {
    ["enabled"] = true
  },
  ["decoration"] = {
    ["active_opacity"] = 1.0,
    ["blur"] = {
      ["enabled"] = true,
      ["passes"] = 1,
      ["size"] = 3,
      ["vibrancy"] = 0.1696
    },
    ["inactive_opacity"] = 1.0,
    ["rounding"] = 5,
    ["rounding_power"] = 2,
    ["shadow"] = {
      ["color"] = (0xee1a1a1a),
      ["enabled"] = true,
      ["range"] = 4,
      ["render_power"] = 3
    }
  },
  ["general"] = {
    ["allow_tearing"] = false,
    ["border_size"] = 3,
    ["col"] = {
      ["active_border"] = {
        ["angle"] = 45,
        ["colors"] = {
          "rgba(af005faa)",
          "rgba(af005faa)"
        }
      },
      ["inactive_border"] = "rgba(595959aa)"
    },
    ["gaps_in"] = 1,
    ["gaps_out"] = 2,
    ["layout"] = "dwindle",
    ["resize_on_border"] = true
  }
})
hl.config({
  ["dwindle"] = {
    ["preserve_split"] = true
  }
})
hl.config({
  ["master"] = {
    ["new_status"] = "master"
  }
})
hl.config({
  ["scrolling"] = {
    ["fullscreen_on_one_column"] = true
  }
})
hl.config({
  ["misc"] = {
    ["disable_hyprland_logo"] = true,
    ["disable_splash_rendering"] = true,
    ["enable_swallow"] = true,
    ["force_default_wallpaper"] = 1,
    ["swallow_regex"] = ".*ghostty.*"
  }
})
hl.config({
  ["input"] = {
    ["follow_mouse"] = 0,
    ["kb_layout"] = "us",
    ["kb_model"] = "",
    ["kb_options"] = "",
    ["kb_rules"] = "",
    ["kb_variant"] = "",
    ["numlock_by_default"] = true,
    ["repeat_delay"] = 300,
    ["repeat_rate"] = 25,
    ["sensitivity"] = 0,
    ["touchpad"] = {
      ["disable_while_typing"] = false,
      ["natural_scroll"] = true
    }
  }
})

-- settings.device
hl.device({
  ["name"] = "syna32a9:00-06cb:ce17-touchpad",
  ["sensitivity"] = 0.8
})
hl.device({
  ["name"] = "ven_0488:00-0488:107e-touchpad",
  ["sensitivity"] = 0.8
})

-- settings.env
hl.env("XCURSOR_SIZE", "16")
hl.env("HYPRCURSOR_SIZE", "16")

-- settings.gesture
hl.gesture({
  ["action"] = "workspace",
  ["direction"] = "horizontal",
  ["fingers"] = 3
})

-- settings.monitor
hl.monitor({
  ["mode"] = "preferred",
  ["output"] = "",
  ["position"] = "auto",
  ["scale"] = "1"
})

-- settings.on
hl.on("hyprland.start", (function()
 hl.exec_cmd('pkill waybar; waybar')
end))

-- settings.window_rule
hl.window_rule({
  ["border_size"] = 0,
  ["match"] = {
    ["float"] = false,
    ["workspace"] = "w[tv1]"
  },
  ["name"] = "no-gaps-wtv1",
  ["rounding"] = 0
})
hl.window_rule({
  ["border_size"] = 0,
  ["float"] = true,
  ["match"] = {
    ["class"] = "^tui.*$"
  },
  ["move"] = ({"monitor_w-window_w", waybar_height}),
  ["name"] = "tui_standalone",
  ["no_anim"] = true,
  ["rounding"] = 0,
  ["stay_focused"] = true
})
hl.window_rule({
  ["match"] = {
    ["class"] = ".*"
  },
  ["name"] = "suppress-maximize-events",
  ["suppress_event"] = "maximize"
})
hl.window_rule({
  ["match"] = {
    ["class"] = "^$",
    ["float"] = true,
    ["fullscreen"] = false,
    ["pin"] = false,
    ["title"] = "^$",
    ["xwayland"] = true
  },
  ["name"] = "fix-xwayland-drags",
  ["no_focus"] = true
})
hl.window_rule({
  ["float"] = true,
  ["match"] = {
    ["class"] = "hyprland-run"
  },
  ["move"] = "20 monitor_h-120",
  ["name"] = "move-hyprland-run"
})

-- settings.workspace_rule
hl.workspace_rule({
  ["gaps_in"] = 0,
  ["gaps_out"] = 0,
  ["workspace"] = "w[tv1]"
})
hl.workspace_rule({
  ["gaps_in"] = 0,
  ["gaps_out"] = 0,
  ["workspace"] = "f[1]"
})

-- hl.layer_rule({
--     match = { namespace = "selection" },
--     no_anim = true,
-- })
-- 
-- hl.layer_rule({
--     match = { namespace = "slurp" },
--     no_anim = true,
-- })
