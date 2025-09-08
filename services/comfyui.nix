{ pkgs, comfyui, ... }:

let comfyui_port = "9091";
in
{
  environment.systemPackages = [
    comfyui.packages.x86_64-linux.comfyui
  ];

  systemd.services.comfyui = {
    enable = true;
    description = "ComfyUI image/video generator";
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      AllowedCPUs = "16-31";
#      Environment = "HSA_OVERRIDE_GFX_VERSION=10.3.0";
      ExecStart = "/run/current-system/sw/bin/sh -c \"${comfyui.packages.x86_64-linux.comfyui}/bin/ComfyUI --base-directory /pool0/ai/comfyui --port ${comfyui_port} --listen 0.0.0.0 --disable-auto-launch --enable-cors-header --cpu\"";
      User = "comfyui";
    };
  };

  users.groups.comfyui = {};
  users.users.comfyui = {
    isSystemUser = true;
    group = "comfyui";
    extraGroups = [ "render" "video" ];
  };

  services.nginx.virtualHosts."comfy.ai.uhsure.com" = {
    extraConfig = "send_timeout 3600s;";

    locations."/" = {
      proxyPass = "http://127.0.0.1:${comfyui_port}";
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
