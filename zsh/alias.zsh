alias ls="ls --color=always"
alias lsa="ls -a --color=always"
alias dl="rm -i"

alias conf="nvim ~/.config"

mkcd() {
    mkdir -p $1
    cd $1
}
