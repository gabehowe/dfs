{ pkgs, inputs, ... }:
{
  # home.file.".config/ghostty/themes/papercolor-dark".text = ''
  # 	palette = 0 = #1c1c1c
  # 	palette = 1 = #af005f
  # 	palette = 2 = #5faf00
  # 	palette = 3 = #d7af5f
  # 	palette = 4 = #5fafd7
  # 	palette = 5 = #808080
  # 	palette = 6 = #d7875f
  # 	palette = 7 = #d0d0d0
  # 	palette = 8 = #585858
  # 	palette = 9 = #5faf5f
  # 	palette = 10= #afd700
  # 	palette = 11= #af87d7
  # 	palette = 12= #ffaf00
  # 	palette = 13= #ff5faf
  # 	palette = 14= #00afaf
  # 	palette = 15= #5f8787
  # 	background = #1c1c1c
  # 	foreground = #d0d0d0
  # 	cursor-color = #5faf5f
  # 	cursor-text = #c6c6c6
  # 	selection-background = #8787af
  # 	selection-foreground = #000000
  # '';
  programs.tmux = {
    enable = true;
    mouse = true;
    clock24 = true;
    keyMode = "vi";
    terminal = "tmux-256color";
    escapeTime = 10;
    focusEvents = true;
    shortcut = "a";
    extraConfig = ''
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };
}
