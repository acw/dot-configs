{ pkgs, ... }:

let llama_port = "9081";
#    llama_model = "/pool0/ai/llama.cpp/L3-70B-Euryale-v2.1-Q4_K_M.gguf";
#    llama_model = "/pool0/ai/llama.cpp/gemma-3-27b-it-abliterated.q5_k_m.gguf";
    llama_model = "/pool0/ai/llama.cpp/L3.3-TRP-BASE-80-70b-Q8_0.gguf";
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
      ExecStart = "/run/current-system/sw/bin/sh -c \"${pkgs.llama-cpp}/bin/llama-server -b 2048 -ub 1024 -c 0 --host 0.0.0.0 --port ${llama_port} -m ${llama_model}\"";
      User = "llama";
    };
  };

  users.groups.llama = {};
  users.users.llama = {
    isSystemUser = true;
    group = "llama";
    extraGroups = [ "render" "video" ];
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
