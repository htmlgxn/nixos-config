# Soft Serve Git Server

Soft Serve is a self-hosted git server running on `boreal`. It exposes a git-over-SSH interface on port 23231 and an HTTP interface (web UI + HTTP clone) on port 23232.

## Connection Details

| | |
|---|---|
| Host | boreal |
| SSH port | 23231 |
| HTTP port | 23232 |
| SSH URL pattern | `ssh://boreal:23231/<repo>` |
| HTTP URL pattern | `http://boreal:23232/<repo>` |

---

## SSH Setup

### 1. Add your key to Soft Serve

Connect to the Soft Serve admin shell using the initial admin key (the ed25519 key in `hosts/boreal/services.nix`):

```bash
ssh -i ~/.ssh/<admin-key> -p 23231 boreal
```

This drops you into the Soft Serve TUI. From there you can manage users, repos, and SSH keys interactively.

To add a new public key for a user non-interactively:

```bash
ssh -i ~/.ssh/<admin-key> -p 23231 boreal user add-pubkey <username> "$(cat ~/.ssh/id_ed25519.pub)"
```

Or create a new user with a key in one step:

```bash
ssh -i ~/.ssh/<admin-key> -p 23231 boreal user create <username> --key "$(cat ~/.ssh/id_ed25519.pub)"
```

### 2. Configure your SSH client

Add a host entry to `~/.ssh/config` to avoid specifying the port every time:

```
Host soft-serve
    HostName boreal
    Port 23231
    User git
    IdentityFile ~/.ssh/id_ed25519
```

With this in place you can use `soft-serve` as the hostname in git URLs:

```
ssh://soft-serve/<repo>
```

Or test the connection:

```bash
ssh soft-serve
```

---

## Creating a Repository

Via the admin shell TUI:

```bash
ssh -p 23231 boreal
```

Non-interactively:

```bash
ssh -p 23231 boreal repo create <repo-name>
```

To create a private repo:

```bash
ssh -p 23231 boreal repo create <repo-name> --private
```

---

## Cloning a Repository

Using the SSH config alias above:

```bash
git clone ssh://soft-serve/<repo-name>
```

Using the full address:

```bash
git clone ssh://boreal:23231/<repo-name>
```

Via HTTP (read-only, no authentication required for public repos):

```bash
git clone http://boreal:23232/<repo-name>
```

---

## Adding as a Remote

### Set as `origin` for a new repo

```bash
git init
git remote add origin ssh://soft-serve/<repo-name>
git push -u origin main
```

### Add as an additional remote

```bash
git remote add soft-serve ssh://soft-serve/<repo-name>
git push soft-serve main
```

### Change an existing remote to point here

```bash
git remote set-url origin ssh://soft-serve/<repo-name>
```

### Mirror an existing repo to Soft Serve

```bash
# Create the repo on soft-serve first, then push all refs
git remote add soft-serve ssh://soft-serve/<repo-name>
git push soft-serve --mirror
```

---

## Pushing an Existing Local Repo

```bash
# From inside the repo directory
ssh -p 23231 boreal repo create <repo-name>
git remote add origin ssh://soft-serve/<repo-name>
git push -u origin main
```

---

## Browsing Repos

Open the web UI in a browser:

```
http://boreal:23232
```

List repos via SSH:

```bash
ssh -p 23231 boreal repo list
```

---

## Common Admin Tasks

### List users

```bash
ssh -p 23231 boreal user list
```

### Remove a public key from a user

```bash
ssh -p 23231 boreal user remove-pubkey <username> <key-id>
```

Key IDs are shown in the TUI or via:

```bash
ssh -p 23231 boreal user info <username>
```

### Delete a repo

```bash
ssh -p 23231 boreal repo delete <repo-name>
```

### Rename a repo

```bash
ssh -p 23231 boreal repo rename <old-name> <new-name>
```

---

## Notes

- The data directory is `/mnt/archive/soft-serve` on boreal. The service will not start if `mnt-archive` is not mounted.
- The `soft-serve` system user owns the data directory. Do not write there directly.
- The initial admin key is the ed25519 key set in `hosts/boreal/services.nix` via `SOFT_SERVE_INITIAL_ADMIN_KEYS`. Once you have added your own key through the admin shell, you can use that for all subsequent admin operations.
