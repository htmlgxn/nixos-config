# Bash shell configuration.
{pkgs, ...}: let
  # On macOS the Nix yt-dlp wrapper doesn't reliably surface its bundled
  # ffmpeg, so pin it explicitly. Other platforms work fine without this.
  ytdlpFfmpegArg =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "--ffmpeg-location ${pkgs.ffmpeg}/bin/ffmpeg "
    else "";
in {
  programs.bash = {
    enable = true;

    # Aliases valid in both shells live in my.shellAliases (nushell.nix);
    # these need bash syntax or only make sense in bash.
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      mkdir = "mkdir -pv";
      grep = "grep --color=auto";
      egrep = "egrep --color=auto";
      fgrep = "fgrep --color=auto";
      ipcheck = "curl ipinfo.io/ip && echo '' && curl ipinfo.io/country";
      gcm = "git add -A && git commit -m";
      gpall = "git push origin main && git push soft main";
      ytdl = "yt-dlp ${ytdlpFfmpegArg}-f 'bestvideo*+bestaudio' -S 'res,br,fps' -t mp4 -o '~/Downloads/output.mp4' --write-thumbnail --convert-thumbnails jpg";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PATH = "$HOME/.local/bin:$PATH"; # uv tools location
    };

    initExtra = ''
      # Fastfetch aliases as functions (aliases don't support arguments)
      ff() { fastfetch; }
      ff-min() { fastfetch --config minimal; }
    '';

    profileExtra = ''
      # manually add to .bash_profile here
    '';
  };
}
