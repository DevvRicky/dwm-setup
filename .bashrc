# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
fastfetch

#Environment
export EDITOR='nvim'

# Starts these scripts with a green color already
#alias unimatrix='unimatrix -c green'
alias pipes.sh='pipes.sh -c 28'
alias tty-clock='tty-clock -C 2'
alias cbonsai='cbonsai -l'

# Restart and Shutdown
alias st='sudo shutdown -P now'
alias rt='sudo shutdown -r now'

# Config
alias cfast='nvim ~/.config/fastfetch/.; cd -'
alias ckitty='nvim ~/.config/kitty/.;'
alias cstatus='sudo nvim ~/dotfiles/slstatus/config.h'
alias mstatus='cd ~/dotfiles/slstatus; sudo make clean install; cd -'
alias cdwm='nvim ~/dotfiles/dwm/config.h'
alias mdwm='cd ~/dotfiles/dwm; sudo make clean install; cd -'
alias gtk30='nvim /home/fierzza/.config/gtk-3.0/settings.ini'
alias gtk40='nvim /home/fierzza/.config/gtk-4.0/settings.ini'
alias xinit='nvim /home/fierzza/.xinitrc'

# Package Manager aliases
alias xr='sudo xbps-remove -o'
alias xq='sudo xbps-query'
alias xi='sudo xbps-install'

# Colors of the ls command
alias ls='ls --color=auto'
export LS_COLORS='di=1;32:fi=0:ln=1;95:pi=33:so=1;95:bd=46;32:cd=46;32:or=31;43:mi=05;37;41'

#its the [user@machine ~] >>
PS1='\[\e[1;32m\][\[\e[1;32m\]\u@\h \[\e[1;95m\]\W\[\e[1;32m\]]\[\e[0m\] >> '

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.local/npm-global/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.Scripts:$PATH"
source "$HOME/.cargo/env"
export ANDROID_HOME=/home/fierzza/Android/Sdk
export ANDROID_SDK_ROOT=/home/fierzza/Android/Sdk
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
export JAVA_HOME=/usr/lib/jvm/openjdk21
export PATH="$JAVA_HOME/bin:$PATH"

# opencode
export PATH=/home/fierzza/.opencode/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"
