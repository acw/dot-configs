{ tailscaleModes, ... }:

{
  services.tailscale = {
    enable = true;

    extraSetFlags = [
    ]
    ++ (if builtins.elem "exit" tailscaleModes then [ "--advertise-exit-node" ] else [ ])
    ++ (if builtins.elem "webserver" tailscaleModes then [ "--webclient" ] else [ ]);
  };
}
