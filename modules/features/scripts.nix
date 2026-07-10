{
  flake.nixosModules.scripts =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      ffmpeg-exe = lib.getExe pkgs.ffmpeg;
      ffmpeg-transcoder =
        pkgs.writeShellScriptBin "transcode-video"
          # sh
          ''
            # Default fallback values
            FPS=""
            INPUT_FILE=""
            OUTPUT_FILE=""

            # Print usage instructions
            usage() {
                echo "Usage: transcode-video -i <input.mp4> -o <output.mov> [-r <fps>]"
                echo "  -i : Input video file path (Required)"
                echo "  -o : Output video file path (Required)"
                echo "  -r : Frame rate / FPS (Optional)"
                exit 1
            }

            # Parse CLI flags and arguments
            while getopts "i:o:r:h" opt; do
                case "$opt" in
                    i) INPUT_FILE="$OPTARG" ;;
                    o) OUTPUT_FILE="$OPTARG" ;;
                    r) FPS="$OPTARG" ;;
                    h|*) usage ;;
                esac
            done

            # Validate that required parameters are provided
            if [ -z "$INPUT_FILE" ] || [ -z "$OUTPUT_FILE" ]; then
                echo "Error: Missing required input or output files."
                usage
            fi

            # Build the dynamic FPS argument if the user supplied the -r flag
            FPS_ARG=""
            if [ -n "$FPS" ]; then
                FPS_ARG="-r $FPS"
            fi

            echo "Transcoding '$INPUT_FILE' to '$OUTPUT_FILE'..."
            if [ -n "$FPS" ]; then echo "Setting frame rate to: $FPS FPS"; fi

            # Execute the conversion using the exact Nix store path for FFmpeg
            ${ffmpeg-exe} \
              -i "$INPUT_FILE" \
              $FPS_ARG \
              -vsync 1 \
              -async 1 \
              -c:v dnxhd \
              -profile:v dnxhr_hq \
              -c:a pcm_s16le \
              -pix_fmt yuv422p \
              "$OUTPUT_FILE"
          '';

    in
    {
      environment.systemPackages = [ ffmpeg-transcoder ];
    };
}
