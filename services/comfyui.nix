{ pkgs, ... }:

let comfyui_port = "9091";
in
{
  environment.systemPackages = [
    pkgs.comfy-ui
  ];

  systemd.services.comfyui = {
    enable = true;
    description = "ComfyUI image/video generator";
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/sh -c \"${pkgs.comfy-ui}/bin/comfy-ui-launcher --port ${comfyui_port}\"";
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
