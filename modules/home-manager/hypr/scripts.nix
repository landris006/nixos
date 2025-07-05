{pkgs, ...}: let
  gpu-screen-recorder = pkgs.gpu-screen-recorder.override {
    ffmpeg = pkgs.ffmpeg_6; # TODO: remove when gpu-screen-recorder gets updated
  };
in rec {
  startReplay = pkgs.writeShellScript "start-replay" ''
    pidof -q gpu-screen-recorder && exit 0
    video_path="$HOME/Videos/gpu-screen-recorder"
    mkdir -p "$video_path"
    ${gpu-screen-recorder}/bin/gpu-screen-recorder \
      -w DP-1 \
      -f 60 \
      -a "default_output|default_input" \
      -c mkv \
      -bm cbr -q 45000 \
      -r 180 \
      -o "$video_path" \
      -sc ${saveVideo}
  '';
  saveVideo = pkgs.writeShellScript "save-video" ''
    notify-send -u low -- "GPU Screen Recorder" "Saving replay..."

    video_path=$1
    video_directory=$(dirname "$video_path")

    window_name="$(hyprctl activewindow -j | jq -r '.initialTitle')"
    if [[ "$window_name" == "null" ]]; then
      window_name="Desktop"
    fi

    mkdir -p "$video_directory/$window_name"
    mv "$1" "$video_directory/$window_name"

    notify-send -u low -- "GPU Screen Recorder" "Replay saved to $video_directory/$window_name"
  '';
  saveReplay = pkgs.writeShellScript "save-replay" ''
    killall -SIGUSR1 gpu-screen-recorder
  '';

  createConfigFiles = pkgs.writeShellScript "create-config-files" ''
    file="$HOME/.config/hypr/monitors.conf"
    if [ ! -f "$file" ]; then
    cat <<EOF > "$file"
    # Example configuration:

    # monitor=,preferred,auto-right,1.0
    # Run nwg-displays to generate config
    EOF
    fi

    file="$HOME/.config/hypr/extra.conf"
    if [ ! -f "$file" ]; then
    cat <<EOF > "$file"
    # Example configuration:

    # windowrule = float, class:^(nwg-displays)$
    EOF
    fi

    file="$HOME/.config/hypr/workspaces.conf"
    if [ ! -f "$file" ]; then
    cat <<EOF > "$file"
    # Example configuration:

    # workspace = 1, monitor:DP-1,default:true
    # workspace = 2, monitor:DP-1,
    # workspace = 3, monitor:DP-1,
    # workspace = 4, monitor:DP-1,
    # workspace = 5, monitor:DP-1,
    # workspace = 6, monitor:DP-2,
    # workspace = 7, monitor:DP-2,
    # workspace = 8, monitor:DP-2,
    # workspace = 9, monitor:DP-2,default:true
    EOF
    fi
  '';
}
