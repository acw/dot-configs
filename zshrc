MACHINE=`uname -m`
OSNAME=`uname -s`
EDITOR=vim

# site-wide settings
if [[ -f /etc/zshrc ]]; then
  . /etc/zshrc
fi

# history
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt inc_append_history

# local functions
fpath=($fpath ~/.system/zsh/functions)

# key bindings
bindkey -e
bindkey "^f" forward-word
bindkey "^b" backward-word

# completion
autoload -U compinit colors promptinit spectrum
compinit
colors
spectrum
promptinit


# Path stuff
typeset -U possible_path_extensions
possible_path_extensions=(
  /opt/local/bin
  /usr/local/bin
  ${HOME}/.cabal/bin
  ${HOME}/.cargo/bin
  ${HOME}/.gem/ruby/2.0.0/bin
  ${HOME}/.ghcup/bin
  ${HOME}/.local/bin
  ${HOME}/Library/Pythin/2.7/bin
  ${HOME}/bin
  ${HOME}/HaLVM
  ${HOME}/saw
)

for x in $possible_path_extensions; do
  if [[ -d $x ]]; then
    export PATH=$PATH:$x
  fi
done

# Some odd OS-specific stuff
if [[ $OSNAME == "Darwin" ]]; then
    alias ls='ls -FG -h'
  if [ -f /opt/local/etc/xml/catalog ] ; then
     export XML_CATALOG_FILES=/opt/local/etc/xml/catalog
  fi
else
    alias ls='ls --color=auto -F -h'
    alias open='xdg-open'
fi
alias grep='grep --color=auto'
alias rm='rm -v'
alias yum='yum --color=auto'

# Term checks
case $TERM in
  "dumb") alias ls='ls --color=none' ;;
  "xterm") export TERM="xterm-256color" ;;
esac

# prompt 196
prompt trevor 031 240 196 000 214

# cabal completion
compdef -a _cabal cabal

# load in local config, if available
if [[ -f ~/.system/zsh/site-config ]]; then
    . ~/.system/zsh/site-config
fi

# Rust configuration
if `which -s rustc >& /dev/null`; then
  export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fi

# load in EC2 stuff, if it's around
if [[ -f ~/.ec2_creds ]]; then
  source ~/.ec2_creds
  if [[ -d /opt/aws ]]; then
    export EC2_HOME=/opt/aws
    export EC2_AMITOOL_HOME=/opt/aws
    export JAVA_HOME=/usr
    export PATH=$PATH:$EC2_AMITOOL_HOME/bin
    echo "EC2 Credentials and tools available."
  else
    echo "EC2 Credentials available."
  fi
fi

export EDITOR
