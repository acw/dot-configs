{config, ...}:
{
  containers.tailscale = {
    autoStart = true;
    ephemeral = true;

    privateNetwork = true;
    hostAddress = "192.168.200.1";
    localAddress = "192.168.200.14";

    bindMounts = {
      "/var/lib/tailscale/" = {
         hostPath = "/pool0/tailscale/";
         isReadOnly = false;
      };
    };

    forwardPorts = [
      {
        containerPort = config.services.tailscale.port;
        hostPort = config.services.tailscale.port;
        protocol = "udp";   
      }
    ];

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
