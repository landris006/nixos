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

  # Required for Tailscale to do *split* DNS instead of hijacking all of it.
  #
  # Without resolved, tailscaled picks the openresolv backend and registers
  # itself exclusively, so 100.100.100.100 becomes the system's only
  # nameserver and every lookup is forwarded through tailscaled. tailscaled
  # learns the real upstream resolvers by reading them back out of resolvconf
  # whenever the link changes -- and on resume/roaming it can read them in the
  # window where NetworkManager has dropped the old entry but not yet written
  # the new one. It then caches an empty upstream list and answers every query
  # with "no upstream resolvers set, returning SERVFAIL" until it is restarted.
  # That is the "NetworkManager says connected but nothing resolves" hang:
  # routing is fine, DNS is dead. Reconnecting the Wi-Fi only helps if the next
  # link change happens to read a populated resolvconf -- it took ~20s to
  # recover on 2026-08-25, and came back with a stale resolver from a previous
  # network still in the list -- so a reboot was the only reliable fix.
  #
  # With resolved, tailscaled registers only the MagicDNS/ts.net domains on the
  # tailscale0 link and ordinary DNS never passes through it. The resolved
  # module also flips networking.networkmanager.dns to "systemd-resolved" and
  # turns networking.resolvconf off on its own.
  services.resolved.enable = true;
}
