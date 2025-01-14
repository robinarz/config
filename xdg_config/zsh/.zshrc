export SHELL=/bin/zsh
export ZPLUG_HOME=$ZDOTDIR/zplug

export LANG=en_US.UTF8

## Import locations
export ZSH_CUSTOM=~/.config/zsh/custom/
export ZSH_ENV_HOME=$HOME/

export XDG_CONFIG_HOME=$HOME/.config/

## ZSH options
setopt functionargzero
setopt hist_ignore_space

## ZSH plugins
autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

# Load zplug
if [[ -d $ZPLUG_HOME ]]; then
    source $ZPLUG_HOME/init.zsh
else
    echo "zplug is not installed in $ZPLUG_HOME. Please install it first."
    return
fi

# Define plugins
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
zplug "junegunn/fzf", hook-build:"./install --bin"

# Lazy load fzf's Ctrl-R integration
bindkey '^r' fzf-history-widget

# Install plugins if missing
if ! zplug check; then
    zplug install
fi

# Load plugins
zplug load

bindkey '^ ' autosuggest-accept
bindkey '^n' autosuggest-accept
 
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'

eval "$(starship init zsh)"
eval "$(mise activate zsh)"

## files include
sources=(
  'aliases'
  'git'
)

for s in "${sources[@]}"; do
  source $HOME/.config/zsh/include/${s}.zsh
done


export LC_ALL=en_US.UTF-8

export HISTSIZE=100000000
export SAVEHIST=$HISTSIZE
export HISTFILE=$HOME/.local/zsh_history

# Go
if [ -d /usr/local/go/bin/ ]; then
  export GOPATH=~/go
  export GOBIN="$GOPATH/bin"
  export PATH="/usr/local/go/bin:$GOBIN:$PATH"
elif [ -d ~/.go/bin/ ]; then
  export GOPATH="$HOME/.gopath"
  export GOROOT="$HOME/.go"
  export GOBIN="$GOPATH/bin"
  export PATH="$GOPATH/bin:$PATH"
fi

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

if [[ -f "$HOME/.zsh_local" ]]; then
  source ~/.zsh_local
fi

# Poetry
if [[ -d "$HOME/.poetry/bin/" ]]; then
  export PATH="$HOME/.poetry/bin/:$PATH"
fi

if [[ -d "$XDG_CONFIG_HOME/bin" ]]; then
  export PATH="$XDG_CONFIG_HOME/bin:$PATH"
fi

export PATH="$HOME/.local/bin/:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "/home/robinho/.bun/_bun" ] && source "/home/robinho/.bun/_bun"
