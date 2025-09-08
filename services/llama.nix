{ pkgs, ... }:

let
  llama_port = "9081";
  #    llama_model = "/llama-cache/DeepSeek-V3-abliterated-Q4_K_M.gguf";
  llama_model = "/pool0/ai/llama.cpp/MN-12B-Mag-Mell-Q8_0.gguf";
in
{
  environment.systemPackages = [
    pkgs.llama-cpp
  ];

  systemd.services.llama = {
    enable = true;
    description = "Llama.cpp LLM server";
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      AllowedCPUs = "0-15";
      Environment = "HSA_OVERRIDE_GFX_VERSION=10.3.0";
      ExecStart = "/run/current-system/sw/bin/sh -c \"${pkgs.llama-cpp}/bin/llama-server -fa -t 16 -c 32768 --host 0.0.0.0 --port ${llama_port} -m ${llama_model}\"";
      #      ExecStart = "/run/current-system/sw/bin/sh -c \"${pkgs.llama-cpp-vulkan}/bin/llama-server -fa -t 16 -c 32768 --host 0.0.0.0 --port ${llama_port} -m ${llama_model}\"";
      User = "llama";
    };
  };

  users.groups.llama = { };
  users.users.llama = {
    isSystemUser = true;
    group = "llama";
    extraGroups = [
      "render"
      "video"
    ];
  };

  services.nginx.virtualHosts."llama.ai.uhsure.com" = {
    extraConfig = "send_timeout 3600s;";

    locations."/" = {
      proxyPass = "http://127.0.0.1:${llama_port}";
      proxyWebsockets = false;
      extraConfig = "
        proxy_redirect default;
        proxy_read_timeout 3600s;
        proxy_connect_timeout 3600s;
        proxy_send_timeout 3600s;
      ";
    };
  };
}
