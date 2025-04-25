{pkgs, ...}: let
  gpu-screen-recorder = pkgs.gpu-screen-recorder.override {
    ffmpeg = pkgs.ffmpeg_6; # TODO: remove when gpu-screen-recorder gets updated
  };
in rec {
  startReplay = pkgs.writeShellScriptBin "start-replay" ''
    pidof -q gpu-screen-recorder && exit 0
    video_path="$HOME/Videos/gpu-screen-recorder"
    mkdir -p "$video_path"
    ${gpu-screen-recorder}/bin/gpu-screen-recorder \
      -w screen \
      -f 60 \
      -a "default_output|default_input" \
      -c mkv \
      -bm cbr -q 45000 \
      -r 180 \
      -o "$video_path" \
      -sc ${saveVideo}/bin/save-video
  '';
  saveVideo = pkgs.writeShellScriptBin "save-video" ''
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
  saveReplay = pkgs.writeShellScriptBin "save-replay" ''
    killall -SIGUSR1 gpu-screen-recorder
  '';
}
