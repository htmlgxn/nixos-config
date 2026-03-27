# Soft Serve Git Server

Soft Serve is a self-hosted git server running on `boreal`. It exposes a git-over-SSH interface on port 23231 and an HTTP interface (web UI + HTTP clone) on port 23232. After the one-time SSH client setup below, all interaction uses the `boreal` and `soft` aliases. On NixOS hosts, `soft` is also a shell alias for `ssh soft` (defined in `modules/home/users/gars-common.nix`), so you can run Soft Serve commands without the `ssh` prefix.

| | |
|---|---|
| Host | boreal |
| SSH port | 23231 |
| HTTP port | 23232 |
| SSH URL pattern | `ssh://soft/<repo>` |
| HTTP URL pattern | `http://boreal.local:23232/<repo>` |

---

## Reaching boreal

`boreal.local` is the mDNS hostname for the machine. Avahi publishes it on the local network — `.local` is the mDNS convention. On any NixOS host (including rpi4) this resolves out of the box because avahi is configured in `modules/system/cli.nix`. On non-NixOS systems you may need to install an mDNS resolver (e.g. `avahi-daemon` on Linux, or use the machine's IP directly).

---

## SSH client config

**NixOS hosts:** `~/.ssh/config` is managed declaratively by home-manager (`modules/home/users/gars-common.nix`). After a rebuild the `boreal` and `soft` entries are already in place — skip the manual steps below. Do not edit `~/.ssh/config` directly; it will be overwritten on the next rebuild.

**Non-NixOS hosts (macOS, Fedora, etc.):** Add the following two stanzas to `~/.ssh/config` manually:

```
Host boreal
    HostName boreal.local
    Port 2200
    User gars
    AddressFamily inet
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes

Host soft
    HostName boreal.local
    Port 23231
    User gars
    AddressFamily inet
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
```

- `AddressFamily inet` — forces IPv4; avahi can return an unusable IPv6 link-local address without this
- `IdentitiesOnly yes` — prevents SSH trying every loaded key before the named one (avoids MaxAuthTries failures when many keys are loaded)

Test both connections from the new host:

```bash
ssh boreal    # opens a shell on boreal
ssh soft      # opens the Soft Serve TUI
```

---

## Adding your key to Soft Serve

The initial admin key is the ed25519 key in `hosts/boreal/services.nix` (`SOFT_SERVE_INITIAL_ADMIN_KEYS`). Use it to bootstrap your own key.

Open the TUI for interactive key/user management:

```bash
ssh -i ~/.ssh/<admin-key> soft
```

Or add a key to an existing user non-interactively:

```bash
ssh -i ~/.ssh/<admin-key> soft user add-pubkey <username> "$(cat ~/.ssh/id_ed25519.pub)"
```

Or create a new user with a key in one step:

```bash
ssh -i ~/.ssh/<admin-key> soft user create <username> --key "$(cat ~/.ssh/id_ed25519.pub)"
```

Once your key is registered, drop `-i ~/.ssh/<admin-key>` — your default key works for all subsequent commands.

---

## Creating a repository

```bash
ssh soft repo create <repo-name>

# private repo:
ssh soft repo create <repo-name> --private
```

---

## Cloning

```bash
git clone ssh://soft/<repo-name>

# HTTP (public repos, read-only, no auth required):
git clone http://boreal.local:23232/<repo-name>
```

---

## Working with remotes

### Set as `origin` for a new repo

```bash
git init
git remote add origin ssh://soft/<repo-name>
git push -u origin main
```

### Add as an additional remote

```bash
git remote add soft ssh://soft/<repo-name>
git push soft main
```

### Change an existing remote URL

```bash
git remote set-url origin ssh://soft/<repo-name>
```

### Mirror an existing repo

```bash
ssh soft repo create <repo-name>
git remote add soft ssh://soft/<repo-name>
git push soft --mirror
```

---

## Pushing an existing local repo

```bash
# From inside the repo directory
ssh soft repo create <repo-name>
git remote add origin ssh://soft/<repo-name>
git push -u origin main
```

---

## Browsing

Web UI: `http://boreal.local:23232`

List repos via SSH:

```bash
ssh soft repo list
```

---

## Admin reference

```bash
# User management
ssh soft user list
ssh soft user info <username>
ssh soft user add-pubkey <username> "<pubkey>"
ssh soft user remove-pubkey <username> <key-id>

# Repo management
ssh soft repo list
ssh soft repo delete <repo-name>
ssh soft repo rename <old-name> <new-name>
```

Key IDs are shown in the TUI or via `ssh soft user info <username>`.
