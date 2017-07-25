MACHINE=`uname -m`
OSNAME=`uname -s`

# site-wide settings
if [[ -f /etc/zshrc ]]; then
  . /etc/zshrc
fi

# history
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt inc_append_history

# local functions
fpath=($fpath ~/.system/zsh/functions)

# emacs key bindings
bindkey -e

bindkey "^f" forward-word
bindkey "^b" backward-word

# completion
autoload -U compinit colors promptinit spectrum
compinit
colors
spectrum
promptinit

export EDITOR=vim

# Path

if [[ -d /opt/local/bin ]]; then
  export PATH=${PATH}:/opt/local/bin
fi

if [[ -d ${HOME}/tools ]]; then
  if [[ -f ${HOME}/tools/selections ]]; then
    typeset -A selections
    selections=( ${=${(f)"$(<${HOME}/tools/selections)"}} )
    for tool in ${(k)selections}; do
      version=$selections[$tool]
      export PATH="${HOME}/tools/${tool}${version}/bin:${PATH}"
      echo "${tool:u} Version: ${version}"
    done
  else
    echo "No selections file found."
  fi
else
  echo "No \${HOME} tools directory found."
fi

if [[ -d ${HOME}/.cabal/bin ]]; then
  export PATH=${HOME}/.cabal/bin:${PATH}
fi

if [[ -d ${HOME}/HaLVM ]]; then
  export PATH=${PATH}:${HOME}/HaLVM/dist/bin
fi

# Fix XML catalog issues
if [[ $OSNAME == "Darwin" ]] ; then
  if [ -f /opt/local/etc/xml/catalog ] ; then
     export XML_CATALOG_FILES=/opt/local/etc/xml/catalog
  fi
fi

# Aliases
if [[ $OSNAME == "Darwin" ]]; then
    alias ls='ls -FG -h'
else
    alias ls='ls --color=auto -F -h'
fi
alias grep='grep --color=auto'
alias rm='rm -v'
alias yum='yum --color=auto'

if [[ $OSNAME != "Darwin" ]]; then
     alias open='gnome-open'
fi

topit() { /usr/bin/top -p `pgrep $1` }
vimfind() { find -name $1 -exec vim {} + }

# ghc switching
if [[ $TERM == "dumb" ]] ; then
  alias ls='ls --color=none'
fi

if [[ $TERM == "xterm" ]] ; then
  export TERM="xterm-256color"
fi

# prompt 196
prompt trevor 031 240 196 000 214

# cabal completion
compdef -a _cabal cabal

# use the default dircolors, despite the awesome 256 color palette
if [[ -f /etc/DIR_COLORS ]]; then
  eval `dircolors -b /etc/DIR_COLORS`
fi

# load in local config, if available
if [[ -f ~/.system/zsh/site-config ]]; then
	. ~/.system/zsh/site-config
fi

# OPAM configuration
if [[ -d ${HOME}/.opam ]]; then
  . ${HOME}/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
  OPAM_VERSION=`opam --version`
  echo "OPAM Version: ${OPAM_VERSION}"
fi

# Ruby configuration
if [[ -d ${HOME}/.gem/ruby/2.0.0/bin ]]; then
  export PATH=$PATH:${HOME}/.gem/ruby/2.0.0/bin
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
