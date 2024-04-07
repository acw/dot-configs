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

      # load in local config, if available
      if [[ -f ~/.system/zsh/site-config ]]; then
          . ~/.system/zsh/site-config
      fi

      prompt trevor 031 240 196 000 214
      if command -v chef &> /dev/null; then
        eval "$(chef shell-init zsh)"
      fi

      if command -v ssh-add >& /dev/null; then
        ssh-add
      fi
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}

# # Rust configuration
# if `which -s rustc >& /dev/null`; then
#   export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
# fi
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
# # Added by eng-bootstrap 2024-03-18 15:21:51
# export PATH="$PATH:/usr/local/google-cloud-sdk/bin"
