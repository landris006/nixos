{config, ...}: {
  services.tailscale = {
    enable = true;

    # Let peers punch through to us directly on UDP 41641 instead of
    # falling back to a relay.
    openFirewall = true;

    # "client" relaxes reverse path filtering, which is what lets traffic
    # come back in when routing through another node as an exit node.
    useRoutingFeatures = "client";

    # Re-applied on every boot: accept SSH from the tailnet, authenticated
    # by Tailscale identity rather than authorized_keys.
    extraSetFlags = ["--ssh"];
  };

  # Peers on the tailnet already authenticated to get there, so let them
  # reach local services without poking individual holes in the firewall.
  networking.firewall.trustedInterfaces = [config.services.tailscale.interfaceName];
}
