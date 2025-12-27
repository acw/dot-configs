{
  config,
  pkgs,
  systemUse,
  lib,
  ...
}:

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
      rm = "rm -v";
      yum = "yum --color=auto";
      vim = "nvim";
      vi = "nvim";
    }
    // (if pkgs.stdenv.isLinux then { open = "xdg-open"; } else { });

    initContent = ''
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

      if [ -S ${config.home.homeDirectory}/.1password/agent.sock ]; then
        export SSH_AUTH_SOCK=${config.home.homeDirectory}/.1password/agent.sock
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
