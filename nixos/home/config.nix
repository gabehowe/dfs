{ pkgs, inputs, ... }:
{
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
      set status-style fg=#d0d0d0,bg=#444444
      set -g window-status-current-style "fg=#d20072,bold,bg=default"
      set -g pane-active-border-style bg=default,fg=#af005f
    '';
  };
}
