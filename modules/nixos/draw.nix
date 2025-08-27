{pkgs, ...}: {
  hardware.opentabletdriver.enable = true;

  environment.systemPackages = with pkgs; [
    krita
    (
      writeTextFile {
        # This can be anything, it's just the name of the derivation in the nix store
        name = "krita-thumbnailer";
        # This is the important part, the path under which this will be installed
        destination = "/share/thumbnailers/kra.thumbnailer";
        # The contents of your thumbnailer, don't forget to specify the full path to executables
        text = ''
          [Thumbnailer Entry]
          Exec=sh -c "${pkgs.unzip}/bin/unzip -p %i preview.png > %o"
          MimeType=application/x-krita;
        '';
      }
    )
  ];
}
