{...}: {
  config = {
    services.xserver.videoDrivers = ["modesetting"];

    # Panel self-refresh is ON again as of 2026-10-13 -- we are testing whether
    # the freeze workaround below is still needed on current kernels.
    #
    # The bug: on Rembrandt (Radeon 680M) with kernels newer than 6.6, the DMCUB
    # display microcontroller hangs ("DMCUB error - collecting diagnostic data"
    # -> "flip_done timed out"), which stops page flips. The screen freezes
    # while audio, input and compute keep running. See Arch bug #78872.
    #
    # The workaround was amdgpu.dcdebugmask=0x610, which disables the whole
    # panel-self-refresh family:
    #   0x10  DC_DISABLE_PSR
    #   0x200 DC_DISABLE_PSR_SU
    #   0x400 DC_DISABLE_REPLAY
    #
    # That costs real battery life -- PSR is what lets the display engine and
    # memory controller idle between frames on a static screen, worth roughly
    # 0.5-1.5 W on this 2560x1600 panel -- which is why it is worth retesting.
    #
    # If the freeze comes back, escalate in this order rather than jumping
    # straight back to 0x610; reports pointed at PSR-SU/Replay, not PSR1:
    #   boot.kernelParams = ["amdgpu.dcdebugmask=0x400"];  # Replay only
    #   boot.kernelParams = ["amdgpu.dcdebugmask=0x600"];  # + PSR-SU
    #   boot.kernelParams = ["amdgpu.dcdebugmask=0x610"];  # + PSR1 (original)
    #
    # The freeze was intermittent, so a clean afternoon proves nothing. Give
    # each step several days of normal use before concluding anything.

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.amdgpu.initrd.enable = true;
  };
}
