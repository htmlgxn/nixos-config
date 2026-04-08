# Nushell configuration.
{config, ...}: {
  programs.nushell = {
    enable = true;

    shellAliases = {
      # ── General ───────────────────────────────────────────────────────
      c = "clear";
      h = "history";
      l = "ls -l";
      la = "ls -a";
      ll = "ls -la";
      edit = "nvim";
      e = "nvim";
      calc = "fend";
      code = "codium";
      weather = "outside -o detailed";
      music = "ncspot";
      br = "broot";
      wiki = "wiki-tui";
      emo = "emoji-picker-cli";
      soft = "ssh soft";
      softrc = "ssh soft repo create";

      # ── Git ───────────────────────────────────────────────────────────
      ga = "git add .";
      gaa = "git add -A";
      gs = "git status";
      gc = "git commit";
      gp = "git push";
      gpom = "git push origin main";
      gpsm = "git push soft main";

      # ── Config Navigation ──────────────────────────────────────────────
      cdn = "cd ${config.my.repoRoot}";
      ef = "nvim ${config.my.repoRoot}/flake.nix";
      ecli = "nvim ${config.my.repoRoot}/modules/home/cli-base-apps.nix";
      egui = "nvim ${config.my.repoRoot}/modules/home/gui-base-apps.nix";

      # ── Misc Navigation ───────────────────────────────────────────────
      cdd = "cd ~/dev";
      cdp = "cd ~/dev/projects";
    };

    environmentVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      UV_PYTHON_DOWNLOADS = "never";
    };

    extraConfig = ''
      # ── Custom commands ──────────────────────────────────────────────

      # Aliases that need shell features are expressed as custom commands in nushell
      def gcm [message: string] { git add -A; git commit -m $message }
      def gpall [] { git push origin main; git push soft main }
      def ipcheck [] { (http get https://ipinfo.io/ip | str trim) + "\n" + (http get https://ipinfo.io/country | str trim) }
      def ytdl [url: string] { yt-dlp -f 'bestvideo*+bestaudio' -S 'res,br,fps' -t mp4 -o '~/Downloads/output.mp4' --write-thumbnail --convert-thumbnails jpg $url }
      def ff [] { fastfetch }
      def ff-min [] { fastfetch --config minimal }

      # PATH
      $env.PATH = ($env.PATH | prepend ($env.HOME | path join ".local" "bin"))
    '';
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
}
