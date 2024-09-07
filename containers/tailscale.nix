{ ... }: {
  containers.tailscale = {
    config = { config, lib, ... }: {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = "server";
        interfaceName = "userspace-networking";
      };

      system.stateVersion = "24.05";

      networking = {
        firewall = {
          enable = true;
          allowedUDPPorts = [ config.services.tailscale.port ];
        };
        useHostResolvConf = lib.mkForce false;
      };

      services.resolved.enable = true;
    };
  };
}
