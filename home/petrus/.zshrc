# vim: foldmethod=marker
#  < zinit >{{{
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# OMZ Lib
zinit wait lucid for \
    OMZL::bzr.zsh \
    OMZL::cli.zsh \
    OMZL::clipboard.zsh \
    OMZL::compfix.zsh \
    OMZL::completion.zsh \
    OMZL::correction.zsh \
    OMZL::directories.zsh \
    OMZL::functions.zsh \
    OMZL::git.zsh \
    OMZL::grep.zsh \
    OMZL::history.zsh \
    OMZL::key-bindings.zsh \
    OMZL::misc.zsh \
    OMZL::prompt_info_functions.zsh \
    OMZL::spectrum.zsh \
    OMZL::termsupport.zsh \
    OMZL::theme-and-appearance.zsh \
    OMZL::vcs_info.zsh


# OMZ Plugin
zinit wait lucid for \
    OMZP::fzf \
    OMZP::git \
    OMZP::helm \
    OMZP::docker \
    OMZP::docker-compose \
    OMZP::kubectl \
    OMZP::extract \
    OMZP::encode64 \
    OMZP::common-aliases \
    OMZP::colored-man-pages \
    OMZP::sudo \
    OMZP::web-search \
    svn OMZP::macos \
    svn OMZP::z

# Others
zinit wait lucid for \
    atinit"zpcompinit; zpcdreplay" Aloxaf/fzf-tab \
    djui/alias-tips \
    andrewferrier/fzf-z \
    paulirish/git-open \
    zsh-users/zsh-completions \
    zsh-users/zsh-syntax-highlighting \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-history-substring-search

# Load starship theme
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship
# -----------------------------------------------------------------------------"}}}

#  < user config >{{{
# -----------------------------------------------------------------------------
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# User configuration
if [[ $UID != 0 ]]; then
    PATH_LOCAL="/Users/petrus/.local/bin"
    PATH_NODE_LOCAL="/Users/petrus/.local/node_modules/.bin"
    PATH_GO_LOCAL="/Users/petrus/.local/go/bin"
    PATH_PYTHON_LOCAL="/Users/petrus/Library/Python/3.10/bin/"
fi
PATH_DISTCC="/usr/lib/distcc/bin"
PATH_DOOM="/home/petrus/.emacs.d/bin"
PATH_MYSQL="/usr/local/mysql/bin"
export PATH="/usr/sbin:/usr/local/sbin:/sbin:${PATH_LOCAL}:${PATH_NODE_LOCAL}:${PATH_GO_LOCAL}:${PATH_PYTHON_LOCAL}:${PATH_DOOM}:${PATH_MYSQL}:${PATH}:${GOPATH}/bin:${KREW_ROOT:-$HOME/.krew}/bin:"
export FPATH="/usr/share/zsh/site-contrib:${FPATH}"
export GOPATH=$HOME/.local/go
export EDITOR="vim"
export BROWSER="open"
export LANG=en_US.UTF-8

if [[ $UID != 0 ]]; then
    # if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
    #     export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    # fi
    # unset SSH_AGENT_PID

    gpgconf --launch gpg-agent
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi

___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi

zle -N history-substring-search-up; zle -N history-substring-search-down
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# proxy
# export http_proxy=socks5://192.168.2.1:23456
# export https_proxy=socks5://192.168.2.1:23456

# NOTE:CONFLICT
# gentoo wiki recommended completion prompt
# autoload -U compinit promptinit
# compinit
# promptinit; prompt gentoo

# enable command auto-correction
# setopt correctall

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"
# -----------------------------------------------------------------------------"}}}

#  < alias >{{{
# -----------------------------------------------------------------------------
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# more powerful ls
alias LS='find -mount -maxdepth 1 -printf "%.5m %10M %#9u:%-9g %#5U:%-5G %TF_%TR %CF_%CR %AF_%AR %#15s [%Y] %p\n" 2>/dev/null'

alias history_stamp='fc -il 1'

alias vi='vim --clean'
alias vim-tiny='vim -u ~/.vim/vim-tiny.vim'

alias mail_read="mail -f $HOME/mbox"

alias man_zh='LANG=zh_CN.utf8 man'

alias preview="fzf --preview 'bat --color \"always\" {}'"

alias ccache='CCACHE_DIR=/var/cache/ccache ccache'

alias spacevim='vim -u ~/Project/SpaceVim/init.vim'

alias yarn_local='yarn --cwd ~/.local'

alias glances='glances --enable-plugin connections,diskio,docker,cloud,floders,fs,ip,sensors,smart,wifi,system,quicklook,alert'

alias proxychains='proxychains -q'

alias aria2c='aria2c --no-conf=true'

alias crictl_k0s='crictl -r unix:///run/k0s/containerd.sock'

alias sudo='sudo '

# unalias fd
# -----------------------------------------------------------------------------"}}}

#  < functions >{{{
# -----------------------------------------------------------------------------
function secret {
  output="$(basename ${1}).$(date +%F).enc"
  gpg --encrypt --armor \
    --output ${output} \
    -r 0xFC0DC147EE125054 \
    "${1}" && echo "${1} -> ${output}"
  # gpg --encrypt --armor -r 0xFC0DC147EE125054 ${1}
}

function reveal {
  output=$(echo "${1}" | rev | cut -c16- | rev)
  gpg --decrypt --output ${output} "${1}" \
    && echo "${1} -> ${output}"
}

function sign {
    gpg --clearsign -u 0xFC0DC147EE125054 ${1}
}

function detach_sign {
    gpg --armor --detach-sign -u 0xFC0DC147EE125054 ${1}
}

function verify {
    gpg --verify ${1}
}

function refresh_yubikey {
    gpg-connect-agent "scd serialno" "learn --force" /bye
}

function gpg_restart {
  pkill gpg
  pkill pinentry
  pkill ssh-agent
  eval $(gpg-agent --daemon --enable-ssh-support)
}

# gpg --local-user [发信者ID] --recipient [接收者ID] --armor --sign --encrypt demo.txt
# -----------------------------------------------------------------------------"}}}
