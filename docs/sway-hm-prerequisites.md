# Sway on Standalone Home Manager Hosts

On NixOS, the `sway` system profile handles all system-level requirements automatically. On standalone Home Manager hosts (Fedora, Ubuntu), the host OS must provide these manually before switching to a `sway` or `sway-full` home profile.

## What Home Manager Handles

Once the system prerequisites are in place, the `sway` home profile provides everything else:

- Sway configuration (`~/.config/sway/config`)
- Waybar, swaylock, swayidle, swaybg, grim, wl-clipboard
- GTK/QT theming, cursor theme, fonts (user-level)
- Fuzzel, mako, terminal emulator
- All keybindings, wallpaper, startup applications

## System Prerequisites

### Required on All Hosts

| Component                                  | Why                                                                           | NixOS equivalent                                                                  |
| ------------------------------------------ | ----------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| **sway** (system package)                  | Needs setuid/capability wrapper for DRM/KMS access                            | `programs.sway.enable`                                                            |
| **polkit**                                 | Privilege escalation for mounting, power management                           | `security.polkit.enable`                                                          |
| **rtkit**                                  | Realtime scheduling for PipeWire/audio                                        | `security.rtkit.enable`                                                           |
| **greetd + tuigreet** (or another greeter) | Login manager that can launch `sway`                                          | `services.greetd`                                                                 |
| **xdg-desktop-portal-wlr**                 | Screen sharing, file dialogs under Wayland                                    | `xdg.portal.wlr.enable`                                                           |
| **xdg-desktop-portal-gtk**                 | GTK file picker integration                                                   | `xdg.portal.extraPortals`                                                         |
| **dconf**                                  | Required by GTK apps for settings storage                                     | `programs.dconf.enable`                                                           |
| **gnome-keyring** (+ PAM integration)      | SSH key agent, credential storage. PAM must start the keyring daemon at login | `services.gnome.gnome-keyring` + `security.pam.services.login.enableGnomeKeyring` |
| **wayland + xwayland**                     | Wayland libraries and X11 compat layer                                        | `environment.systemPackages`                                                      |
| **PipeWire** (+ wireplumber)               | Audio — pactl/wpctl commands in sway config depend on this                    | `modules/system/cli.nix`                                                          |
| **GTK_THEME=Adwaita-dark**                 | System-wide dark theme default for GTK apps                                   | `environment.variables`                                                           |
| **PAM swaylock entry**                     | swaylock needs PAM auth to unlock the screen                                  | implicit on NixOS                                                                 |

### Fonts (System-Level)

Install these system-wide for waybar and sway to render correctly:

- Roboto Mono (primary UI font)
- OpenMoji Color (emoji — not Noto)
- JetBrains Mono Nerd Font (terminal/waybar icons)

## Fedora (fedora-mac / Asahi)

```bash
# Sway and Wayland
sudo dnf install sway wayland xorg-x11-server-Xwayland

# Login manager
sudo dnf install greetd greetd-tuigreet
sudo systemctl enable greetd

# Portal and desktop integration
sudo dnf install xdg-desktop-portal-wlr xdg-desktop-portal-gtk
sudo dnf install dconf

# Security / auth
sudo dnf install polkit rtkit
sudo dnf install gnome-keyring

# Audio (likely already present)
sudo dnf install pipewire pipewire-pulseaudio wireplumber

# GTK dark theme default
echo 'GTK_THEME=Adwaita-dark' | sudo tee -a /etc/environment

# Fonts
sudo dnf install google-roboto-mono-fonts
# OpenMoji Color is not in Fedora repos — install manually:
#   Download TTF from https://github.com/hfg-gmuend/openmoji/releases
#   Place in ~/.local/share/fonts/ and run fc-cache -fv
# JetBrains Mono Nerd Font is not in Fedora repos (base jetbrains-mono-fonts-all exists but lacks Nerd Font glyphs):
#   Download from https://www.nerdfonts.com/font-downloads
#   Place in ~/.local/share/fonts/ and run fc-cache -fv

# PAM for swaylock — create /etc/pam.d/swaylock:
sudo tee /etc/pam.d/swaylock <<'EOF'
auth    include login
EOF
```

Configure greetd to launch sway (`/etc/greetd/config.toml`):

```toml
[terminal]
vt = 1

[default_session]
command = "tuigreet --cmd sway"
user = "greeter"
```

## Ubuntu (Jetson / JetPack)

```bash
# Sway and Wayland
sudo apt install sway xwayland

# Login manager
# greetd is not in Ubuntu repos — install from source or use an alternative
# Option A: build greetd from source (https://git.sr.ht/~kennylevinsen/greetd)
# Option B: use ly or another console greeter
# Option C: start sway from .bash_profile (simplest for single-user)

# Portal and desktop integration
sudo apt install xdg-desktop-portal-wlr xdg-desktop-portal-gtk
sudo apt install dconf-cli

# Security / auth
sudo apt install policykit-1 rtkit
sudo apt install gnome-keyring

# Audio
sudo apt install pipewire pipewire-pulse wireplumber

# GTK dark theme default
echo 'GTK_THEME=Adwaita-dark' | sudo tee -a /etc/environment

# Fonts
sudo apt install fonts-roboto-unhinted  # includes Roboto Mono
sudo apt install fonts-openmoji         # available on Ubuntu 23.04+
# JetBrains Mono Nerd Font is not in Ubuntu repos (base fonts-jetbrains-mono exists but lacks Nerd Font glyphs):
#   Download from https://www.nerdfonts.com/font-downloads
#   Place in ~/.local/share/fonts/ and run fc-cache -fv

# PAM for swaylock
sudo tee /etc/pam.d/swaylock <<'EOF'
auth    include login
EOF
```

### Jetson-Specific Notes

- The Jetson runs JetPack Ubuntu with NVIDIA drivers. Sway requires the `nvidia-drm` kernel module loaded with `modeset=1`. Add `nvidia-drm.modeset=1` to kernel boot parameters if not already set.
- Sway does not officially support NVIDIA proprietary drivers. If the Jetson uses the proprietary NVIDIA stack, set `WLR_NO_HARDWARE_CURSORS=1` in the environment and expect potential rendering issues.
- If using the open-source nouveau driver (unlikely on Jetson), sway should work without extra configuration.
- The `CUDA_PATH` and `LD_LIBRARY_PATH` variables set in `hosts/jetson/home.nix` are for compute workloads and do not conflict with sway.

### Starting Sway Without greetd

If installing a greeter is impractical, auto-start sway from TTY1.

**Bash** — via `programs.bash.profileExtra` in home-manager (writes to `~/.bash_profile`):

```nix
programs.bash.profileExtra = ''
  if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec sway
  fi
'';
```

**Nushell** — via `programs.nushell.extraLogin` in home-manager (writes to `login.nu`):

```nix
programs.nushell.extraLogin = ''
  if ($env.WAYLAND_DISPLAY? | is-empty) and ((tty) == "/dev/tty1") {
      exec sway
  }
'';
```

> **Note:** Nushell's environment handling can cause issues launching Wayland compositors directly. If sway fails to create a backend, use `exec bash -c 'exec sway'` instead.

## Fontconfig

On NixOS, `fonts.fontconfig.defaultFonts.emoji` sets OpenMoji Color as the system emoji font. Home-manager can discover user-installed fonts but cannot set default font families — that's a NixOS-only option.

On standalone HM hosts, create `~/.config/fontconfig/fonts.conf`:

```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <!-- Default emoji font -->
  <alias>
    <family>emoji</family>
    <prefer>
      <family>OpenMoji Color</family>
    </prefer>
  </alias>

  <!-- Default monospace font -->
  <alias>
    <family>monospace</family>
    <prefer>
      <family>Roboto Mono</family>
    </prefer>
  </alias>
</fontconfig>
```

Then run `fc-cache -fv` to rebuild the font cache.

## Switching to a Sway Profile

Once prerequisites are installed, update the output in `parts/home.nix`:

```nix
fedora-mac = {
  userName = "htmlgxn";
  homeProfile = "sway";       # was "cli"
  system = "aarch64-linux";
  homeOverlays = [];
};
```

Then rebuild: `nhms` or `home-manager switch --flake .#fedora-mac`.

## Verifying

After switching, confirm:

1. `sway --version` works (system sway is installed)
2. `swaylock` can authenticate (PAM is configured)
3. `wpctl status` shows audio devices (PipeWire is running)
4. Logging in via greetd/tuigreet launches sway
5. Waybar renders with correct fonts and icons
