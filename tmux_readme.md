

set -g @plugin 'tmux-plugins/tpm'
# tmux-sensible: 基本的なオプションをセットする
set -g @plugin 'tmux-plugins/tmux-sensible'
# tmux-yank
set -g @plugin 'tmux-plugins/tmux-yank'
# tmux-resurrect: save and restore session on reboot
# save: prefix+C-s
# restore: prefix+C-r
set -g @plugin 'tmux-plugins/tmux-resurrect'
# tmux-continuum: automatic save-restore sessions
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @continuum-restore 'on'
set -g @continuum-boot 'on'
set -g @plugin 'tmux-plugins/tmux-cpu'

set -g @plugin 'tmux-plugins/tmux-battery'
set -g @plugin 'tmux-plugins/tmux-net-speed'
# tmux-logging: capture the output
# prefix+P: toggle logging
# prefix+alt+p: capture
set -g @plugin 'tmux-plugins/tmux-logging'
set -g @plugin 'tmux-plugins/tmux-copycat'
# tmux-sidebar: show dir tree
# prefix+Tab: toggle
set -g @plugin 'tmux-plugins/tmux-sidebar'
# tmux-sessionist: session manipulation
# prefix+g: listup sessions
# prefix+C: create new sesssion with name
# prefix+X: kill current session
# prefix+S: switche to last session
# prefix+@: current pane into a new session
set -g @plugin 'tmux-plugins/tmux-sessionist'
