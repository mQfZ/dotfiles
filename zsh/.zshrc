export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export HISTFILE="$XDG_STATE_HOME/zsh/history"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"

export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py"

autoload -U colors && colors

alias ls="ls --color=always"
alias lsa="ls -a --color=always"
alias dl="rm -i"

alias conf="nvim ~/.config"

mkcd() {
    mkdir -p $1
    cd $1
}

setopt sharehistory

colors.256() {
	for fgbg in {38..48}; do
		for color in {0..256}; do
			printf "\e[${fgbg};5;${color}m ${color}\t\e[0m"
			if [[ $((($color + 1) % 10)) == 0 ]]; then
				printf "\n"
			fi
		done
		echo
	done
}

session.competitive-programming() {
    SESSIONNAME="competitive-programming"
    tmux has-session -t $SESSIONNAME &> /dev/null

    if [ $? != 0 ]; then
        tmux new-session -s $SESSIONNAME -d
        tmux rename-window -t $SESSIONNAME main
        tmux send-keys -t $SESSIONNAME:main "cd ~/proj/cp" Enter
        tmux send-keys -t $SESSIONNAME:main "nvim ." Enter
        tmux new-window -t $SESSIONNAME -n git
        tmux send-keys -t $SESSIONNAME:git "cd ~/proj/cp" Enter
        tmux send-keys -t $SESSIONNAME:git "clear" Enter
        tmux select-window -t $SESSIONNAME:main
    fi

    tmux attach -t $SESSIONNAME
}

session.dotfiles() {
    SESSIONNAME="dotfiles-config"
    tmux has-session -t $SESSIONNAME &> /dev/null

    if [ $? != 0 ]; then
        tmux new-session -s $SESSIONNAME -d
        tmux rename-window -t $SESSIONNAME dotfiles
        tmux send-keys -t $SESSIONNAME:dotfiles "cd ~/proj/dotfiles" Enter
        tmux send-keys -t $SESSIONNAME:dotfiles "nvim ." Enter
        tmux new-window -t $SESSIONNAME -n config
        # No $SESSIONNAME:config because it gives an error
        tmux send-keys -t $SESSIONNAME "cd ~/.config" Enter
        tmux send-keys -t $SESSIONNAME "clear" Enter
        tmux new-window -t $SESSIONNAME -n git
        tmux send-keys -t $SESSIONNAME:git "cd ~/proj/dotfiles" Enter
        tmux send-keys -t $SESSIONNAME:git "clear" Enter
        tmux select-window -t $SESSIONNAME:dotfiles
    fi

    tmux attach -t $SESSIONNAME
}

PROMPT="\
%{$fg[magenta]%}[%{$reset_color%}\
%{$fg_bold[blue]%}%n%{$reset_color%}\
%{$fg[magenta]%}@%{$reset_color%}\
%{$fg_bold[red]%}%~%{$reset_color%}\
%{$fg[magenta]%}]%{$reset_color%}
 %{$fg_bold[cyan]%}>%{$reset_color%} "

source $ZDOTDIR/plugin/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZDOTDIR/plugin/zsh-autosuggestions/zsh-autosuggestions.zsh
