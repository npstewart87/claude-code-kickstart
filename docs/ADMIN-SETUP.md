# Admin Setup — Remote Hub Checklist

For setting this up on a cloud VM for someone else (the "remote hub" pattern).
Total time: ~30 minutes.

## The VM

1. Any Ubuntu 24.04 VM — 2GB RAM minimum, 4GB comfortable (e.g. AWS Lightsail
   $12–24/mo)
2. **Security first:**
   - Join it to your [Tailscale](https://tailscale.com) network
     (`curl -fsSL https://tailscale.com/install.sh | sh && sudo tailscale up --ssh`)
   - Close ALL public firewall ports (SSH included) once Tailscale SSH works —
     the tailnet is the only door
   - `sudo apt install unattended-upgrades` for automatic security patches
3. Install Claude Code: `curl -fsSL https://claude.ai/install.sh | bash`
4. Clone this repo on the VM and run `./install.sh --skills all --rails`

## Their laptop

1. Install Tailscale, sign in with YOUR Tailscale account (the end user does
   not need their own account; disable key expiry for their device in the
   admin console)
2. Test: `ssh <user>@<vm-hostname>` in their terminal → should land in the
   CLAUDE HUB greeting
3. First run: type `go`, complete the claude.ai login (their account — a Pro
   subscription beats API billing for predictable cost)

## Obsidian on their laptop (optional but great)

1. Install [Syncthing](https://syncthing.net) on the VM and their laptop
   (Windows: SyncTrayzor is the friendly wrapper)
2. Share the VM's `~/vault` folder to their laptop
3. Install [Obsidian](https://obsidian.md), open the synced folder as a vault

## Hand-off

Give them `docs/USER-GUIDE.md`. The daily loop they need to remember:
**terminal → `ssh <hub>` → `go` → talk.**
