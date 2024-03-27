{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;
    defaultKeymap = "emacs";

    history.size = 1000;
    history.path = "${config.xdg.dataHome}/.zsh_history";
    
    shellAliases = {
      ls = "ls --color=auto -F -h";
      grep = "grep --color=auto";
      open = "xdg-open";
      rm = "rm -v";
      yum = "yum --color=auto";
      vim = "nvim";
      vi = "nvim";
    };

    initExtra = ''
      fpath+=(${config.home.homeDirectory}/.system/programs/zsh/functions/)
      autoload -U colors promptinit spectrum
      colors
      spectrum
      promptinit

      prompt trevor 031 240 196 000 214
      eval "$(chef shell-init zsh)"
    '';
  };
}


# # key bindings
# bindkey -e
# bindkey "^f" forward-word
# bindkey "^b" backward-word
# 
# # Path stuff
# typeset -U possible_path_extensions
# possible_path_extensions=(
#   /opt/local/bin
#   /usr/local/bin
#   ${HOME}/.cargo/bin
#   ${HOME}/.gem/ruby/2.0.0/bin
#   ${HOME}/.local/bin
#   ${HOME}/Library/Pythin/2.7/bin
#   ${HOME}/bin
#   ${HOME}/.elan/bin
# )
# 
# # cabal completion
# compdef -a _cabal cabal
# 
# # load in local config, if available
# if [[ -f ~/.system/zsh/site-config ]]; then
#     . ~/.system/zsh/site-config
# fi
# 
# # Rust configuration
# if `which -s rustc >& /dev/null`; then
#   export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
# fi
# 
# # load in EC2 stuff, if it's around
# if [[ -f ~/.ec2_creds ]]; then
#   source ~/.ec2_creds
#   if [[ -d /opt/aws ]]; then
#     export EC2_HOME=/opt/aws
#     export EC2_AMITOOL_HOME=/opt/aws
#     export JAVA_HOME=/usr
#     export PATH=$PATH:$EC2_AMITOOL_HOME/bin
#     echo "EC2 Credentials and tools available."
#   else
#     echo "EC2 Credentials available."
#   fi
# fi
# 
# if `which -s podman >& /dev/null` ; then
#   echo "Using podman instead of Docker."
#   alias docker=podman
# fi
# 
# if `which -s ssh-add >& /dev/null`; then
#   ssh-add
# fi
# 
# if `which nvim >& /dev/null`; then
#   alias vim=nvim
#   alias vi=nvim
#   EDITOR=nvim
# fi
# 
# source ~/.system/zsh/zsh-auto-notify/auto-notify.plugin.zsh
# 
# export EDITOR
# 
# # The next line updates PATH for the Google Cloud SDK.
# if [ -f "${HOME}/.local/google-cloud-sdk/path.zsh.inc" ]; then
#   . "${HOME}/.local/google-cloud-sdk/path.zsh.inc";
# fi
# 
# The next line enables shell command completion for gcloud.
# if [ -f "${HOME}/.local/google-cloud-sdk/completion.zsh.inc" ]; then
#   . "${HOME}/.local/google-cloud-sdk/completion.zsh.inc";
# fi
# 
# if `which opam >& /dev/null`; then
#   eval $(opam env --switch=default)
# fi
# 
# # Added by eng-bootstrap 2024-01-03 09:26:04
# autoload -Uz compinit && compinit; eval "$(chef shell-init zsh)"
# 
# # Added by eng-bootstrap 2024-03-18 15:21:51
# export PATH="$PATH:/usr/local/google-cloud-sdk/bin"
