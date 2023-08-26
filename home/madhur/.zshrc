# zmodload zsh/datetime
# setopt PROMPT_SUBST
# PS4='+$EPOCHREALTIME %N:%i> '

# logfile=$(mktemp zsh_profile.XXXXXXXX)
# echo "Logging to $logfile"
# exec 3>&2 2>$logfile

# setopt XTRACE

## Zsh initialization
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="madhur"
#plugins=(zsh-syntax-highlighting zsh-autosuggestions autoswitch_virtualenv fzf-tab  zsh-history-substring-search zsh-fzf-history-search) 
plugins=(zsh-syntax-highlighting zsh-autosuggestions autoswitch_virtualenv fzf-tab zsh-fzf-history-search) 
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh
## 

## Load my user defined aliases and functions
source ~/.aliases
source ~/.functions
##

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$HOME/scripts:$HOME/company:$PATH"
fi
PATH="$PATH:$HOME/maven/bin:$HOME/gradle/bin"
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
export SYSTEMD_PAGER=

## node version manager initialization
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

[ -z "$PS1" ] && return
##

# place this after nvm initialization!
autoload -U add-zsh-hook
add-zsh-hook chpwd load-nvmrc
load-nvmrc
## End of .nvmrc handling

## Android tools in PATH
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/platform-tools/bin:$PATHexport PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/tools/bin:$PATHexport PATH=$ANDROID_HOME/build-tools/32.0.0:$PATH
export PATH=$ANDROID_HOME/build-tools/32.0.0/bin:$PATH
export PATH=$ANDROID_HOME/bundle-tool:$PATH
## 

## Kubernetes
export KUBECONFIG=~/.kube/config:~/.kube/eks-pt:~/.kube/eks-prod
##

## SDK Man 
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
##

export NODE_ENV=development
export GLOBAL_AGENT_HTTP_PROXY=http://127.0.0.1:8888
export ZK_URL=localhost:2181
export startuser=100000
export incrementuser=10000

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin:$HOME/go/bin:$HOME/.cabal/bin"
export PATH=/usr/bin:$PATH:/usr/local/go/bin:$HOME/.cargo/bin:/home/madhur/Downloads/mysql57/bin

## Linux handling
export PKG_CONFIG_PATH=/usr/lib64/pkgconfig:/usr/share/pkgconfig:/usr/share/wayland-protocols:/usr/local/include:/usr/local/include/libbamf3:/usr/local/share:/usr/local/share/vala/vapi
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib64/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig:/usr/lib/openssl-1.1/pkgconfig:/usr/lib/openssl-1.1
##

## More paths
export PATH=$HOME/etcd:/usr/local/vitess/bin:/home/madhur/.gem/ruby/3.0.0/bin:${PATH}

## Tiling window manager
export _JAVA_AWT_WM_NONREPARENTING=1

[ -f "$HOME/company/passwords.env" ] && source ~/company/passwords.env

## Auto jump script (Replaced by zoxide for now)
#[[ -s /home/madhur/.autojump/etc/profile.d/autojump.sh ]] && source /home/madhur/.autojump/etc/profile.d/autojump.sh
##

## Initialize starship prompt
eval "$(starship init zsh)"
##

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
if [[ $TERM == "xterm-256color" ]]
then
#(cat ~/.cache/wal/sequences &)
fi

## ghcup for haskell (Not using haskell for now)
#[ -f "/home/madhur/.ghcup/env" ] && source "/home/madhur/.ghcup/env" # ghcup-env
##

## Fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
##

## GOlang and GVM
#source /home/madhur/.gvm/scripts/gvm
#export GOPATH="$GOPATH:/home/madhur/go"
##

## List of Zstyles
#zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:default' menu yes select search
# all Tab widgets
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
#bindkey -M menuselect '\r' .accept-line
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
## End of zstyles


## Define color styles to be used by exa, ls and ll commands
export EXA_COLORS="uu=0:gu=0"
eval "$(dircolors ~/.dir_colors)"
## End of color styles

colorscript random

export EDITOR=nvim
[[ -s "/home/madhur/.gvm/scripts/gvm" ]] && source "/home/madhur/.gvm/scripts/gvm"
eval "$(zoxide init zsh)"

#eval "$(atuin init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"
export PATH="/home/madhur/github/personal/git-fuzzy/bin:$PATH"

# nnn env variables
source ~/.config/nnn/config

#export HOST=$(hostname)
