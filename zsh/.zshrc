export CODE_HOME="$HOME/code"
export LOCAL_HOME="$CODE_HOME/local"
export XDG_CONFIG_HOME="$CODE_HOME/config"
export XDG_CACHE_HOME="$LOCAL_HOME/cache"
export XDG_DATA_HOME="$LOCAL_HOME/share"
export XDG_STATE_HOME="$LOCAL_HOME/state"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
PATH=$PATH:"$XDG_CONFIG_HOME/scripts"
PATH=$PATH:"$CARGO_HOME/bin"

setopt sharehistory

alias ls="eza"
eval "$(zoxide init --cmd cd zsh)"

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/zsh/starship.toml"
export STARSHIP_CACHE="$XDG_CACHE_HOME/starship"
eval "$(starship init zsh)"

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
