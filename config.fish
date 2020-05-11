set -x NVM_DIR ~/.nvm
set -xU EDITOR nvim

nvm use default --silent

alias ll "ls -lash"
alias tmuxkill "tmux kill-server"
alias tmuxmain "tmux new -s main"
alias fishconfig "nvim ~/.config/fish/config.fish"
alias nvimconfig "nvim ~/.config/nvim/init.vim"
alias tmuxconfig "nvim ~/.tmux.conf"
alias alacrittyconfig "nvim ~/.config/alacritty/alacritty.yml"
