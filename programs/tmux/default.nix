{ ... }:

{
  programs.tmux = {
    enable = true;
    keyMode = "vi";

    extraConfig = ''
      if-shell 'test "$(uname)" = "Darwin"' {
        set-option -g default-command "reattach-to-user-namespace -l zsh"
      }
      
      set -g default-terminal "xterm-256color"
      set -sa terminal-overrides ",xterm-256color:RGB"
      set -g focus-events on
      set -g set-clipboard on
      set -g mouse on
      set -g mode-keys vi
      set -s extended-keys on
      set-option -g xterm-keys on
      set -as terminal-features 'xterm*:extkeys'
      set-option -sg escape-time 150
      
      # Use v and s to split windows, like vim
      bind-key v split-window -h
      unbind-key s
      bind-key s split-window -v
      
      # small pane resizing
      bind-key -n C-M-h resize-pane -L 1
      bind-key -n C-M-l resize-pane -R 1
      bind-key -n C-M-k resize-pane -U 1
      bind-key -n C-M-j resize-pane -D 1
      bind-key -n M-k   send-keys -R C-l \; clear-history
      
      # default statusbar colors
      set-option        -g status-style fg=colour136,bg=colour238
      set-option        -g window-status-style fg=colour244
      set-option        -g window-status-current-style fg=colour166
      set-option        -g pane-border-style fg=colour238
      set-option        -g pane-active-border-style fg=colour240
      set-option        -g message-style fg=colour166,bg=colour238
      set-option        -g display-panes-active-colour colour33  #blue
      set-option        -g display-panes-colour colour166 #orange
      set-window-option -g clock-mode-colour colour64  #green
      
      set -g window-status-format "#[fg=colour233,bg=colour245] #I:#W#F #[bg=colour238] "
      set -g window-status-current-format "#[fg=colour15,bg=colour25] #I:#W#F #[fg=colour136,bg=colour238]"
      set -g status-left '#[fg=colour3,bg=colour238]#h#[fg=colour136,bg=colour238] | '
      set -g status-right '|#[fg=colour252,bg=colour238] %a %b %d %I:%M%p '
      set -g status-right-length 40
      set -g status-left-length  20
    '';
  };
}
