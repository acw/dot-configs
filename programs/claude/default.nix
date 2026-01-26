{
  config,
  lib,
  pkgs,
  systemUse,
  ...
}:

let
  isWork = lib.strings.hasInfix "work" systemUse;
in
{
  home.packages = with pkgs; [
    claude-code
  ];

  age = if isWork then { } else { secrets.claude_api_key.file = ../../data/claude_api_key.age; };

  home.file = {
    ".claude/settings.json" = {
      enable = !isWork;
      executable = false;
      force = true;
      text = builtins.toJSON rec {
        apiKeyHelper = "${config.home.homeDirectory}/.claude/emit_api_key";
        model = env.ANTRHOPIC_DEFAULT_SONNET_MODEL;
        env = {
          ANTHROPIC_BASE_URL = "https://nano-gpt.com/api";
          ANTHROPIC_API_KEY = "";
          ANTRHOPIC_DEFAULT_OPUS_MODEL = "claude-opus-4-5-20251101:thinking";
          ANTRHOPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-4-5-20250929-thinking";
        };
      };
    };

    ".claude/emit_api_key" = {
      enable = !isWork;
      executable = true;
      force = true;
      text = "cat ${config.age.secrets.claude_api_key.path}";
    };
  };
}
