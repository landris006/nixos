{...}: {
  # Laptop power management. Nothing else on this host switches policy when the
  # charger is pulled: amd-pstate-epp sits at balance_performance and the ACPI
  # platform profile sits at "balanced" on AC and battery alike. TLP is what
  # drives both off the power source.
  #
  # TLP was removed once before (1b3adda) because it killed the built-in
  # speakers. That config only set START/STOP_CHARGE_THRESH_BAT0, which are
  # ThinkPad-only knobs and do nothing on an IdeaPad -- so the breakage came
  # entirely from TLP's *defaults*. See SOUND_POWER_SAVE_* below.
  services.tlp = {
    enable = true;

    settings = {
      # --- Audio: the reason TLP was removed last time ----------------------
      #
      # The built-in speakers hang off a Conexant SN6140 on card1
      # (PCI 0000:04:00.6, "Ryzen HD Audio Controller"). That codec does not
      # reliably come back from runtime suspend -- the sink stays present in
      # PipeWire and simply plays silence until snd_hda_intel is reloaded.
      #
      # TLP's default SOUND_POWER_SAVE_ON_BAT=1 drops the HDA idle timeout to
      # 1 second, 10x more aggressive than the kernel default of 10 that this
      # machine runs on today without trouble. At 1s the codec suspends between
      # stream setup and first playback, which is what silences the speakers.
      #
      # So: pin both states to 10, i.e. exactly the known-good value already in
      # effect, and leave the controller setting at the kernel default (Y, also
      # what is in effect today -- 04:00.6 runtime-suspends fine, it is the
      # timing that breaks it, not D3 itself).
      #
      # If the speakers ever go quiet again, set both of these to 0 to take HDA
      # power saving out of the picture entirely; it costs well under half a
      # watt.
      SOUND_POWER_SAVE_ON_AC = 10;
      SOUND_POWER_SAVE_ON_BAT = 10;
      SOUND_POWER_SAVE_CONTROLLER = "Y";

      # --- Platform profile -------------------------------------------------
      # /sys/firmware/acpi/platform_profile, via ideapad-laptop. "low-power"
      # lowers the EC's sustained SoC power limits. This is the single largest
      # win here and nothing was driving it before.
      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # --- CPU --------------------------------------------------------------
      # amd-pstate-epp only offers performance/powersave as governors; the real
      # control is the energy-performance preference, so keep the governor at
      # powersave in both states and vary EPP instead.
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # Caps the 7735HS at its 3.2 GHz base on battery. The bluntest setting in
      # this file -- drop it to 1 if battery-powered work feels sluggish.
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # --- Bus / device power -----------------------------------------------
      # ASPM is at "default" (firmware's choice) today; powersupersave lets the
      # PCIe links reach their deepest states on battery.
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";

      # "auto" on both matches what the kernel already does on this machine.
      # TLP's AC default is "on", which would *disable* runtime PM while
      # plugged in -- a regression against current behaviour.
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";

      # --- Wi-Fi ------------------------------------------------------------
      # Intel AX210. NetworkManager leaves powersave at "default" today, which
      # means the driver's own balanced scheme and no TLP involvement.
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # --- USB --------------------------------------------------------------
      # USB 3-3 is the Intel 8087:0032 Bluetooth radio behind btusb. Autosuspend
      # on a BT adapter is a well-known source of A2DP stutter, and this host
      # drives AirPods over classic Bluetooth, so keep it excluded.
      # USB_EXCLUDE_AUDIO is TLP's default but stated here deliberately given
      # the history above.
      USB_AUTOSUSPEND = 1;
      USB_EXCLUDE_AUDIO = 1;
      USB_EXCLUDE_BTUSB = 1;
    };
  };

  # Charge limiting is NOT done here. TLP's charge thresholds are ThinkPad-only;
  # this laptop uses ideapad-laptop's conservation_mode instead, at
  # /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode. It is
  # currently on (charge capped near 60%) and persists in the EC across boots,
  # so nothing in this config needs to set it.
}
