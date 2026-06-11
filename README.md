# Claude Code Kickstart

A plug-and-play setup that makes Claude Code organized and stupid-proof for
anyone — especially people who aren't developers. Built from setting up
Claude Code for friends and family who just want it to *work*.

## What it does

- **One entry point.** Every session starts in `~/CLAUDE-KICKOFF/` — a lobby
  where Claude lists your projects and asks what you want to do.
- **Self-enforcing organization.** A master CLAUDE.md teaches Claude to file
  every piece of work into `~/projects/<name>/` (copied from a template),
  so nothing ever lands in random folders — even if the user never thinks
  about files at all.
- **A second brain that writes itself.** Claude logs decisions and progress
  to an Obsidian-compatible vault at `~/vault/` as you work. Point the
  Obsidian app at it (locally or via Syncthing from another machine) and
  watch the graph grow.
- **Optional skill bundles** fetched from their official sources at install
  time: [Everything-Claude-Code](https://github.com/affaan-m/everything-claude-code),
  [Superpowers](https://github.com/anthropics/claude-plugins-official), and the
  [Hermes Agent skill library](https://github.com/NousResearch/hermes-agent).
- **Optional safety rails** — a `settings.json` permission set that lets
  everyday use flow without approval prompts while hard-blocking `sudo` and
  system-level damage. (Instructions get ~70% compliance; permission rules
  get 100%.)
- **Type `go` to start.** The installer adds a login greeting so the only
  thing to remember is one word.

## Install

```bash
# 1. Install Claude Code if you haven't
curl -fsSL https://claude.ai/install.sh | bash

# 2. Kickstart
git clone https://github.com/npstewart87/claude-code-kickstart
cd claude-code-kickstart
./install.sh --skills all --rails
```

Open a new terminal, type `go`, log in once with your claude.ai account
(a Pro subscription — flat monthly, no API billing), and you're set.

Flags: `--skills all|ecc,superpowers,hermes|none` (default none) ·
`--rails` install the permission preset (skipped if you already have a
settings.json) · `--no-bashrc` skip the greeting/alias.

## Remote-hub variant

This setup shines on a small cloud VM (the person SSHes in from any laptop and
their whole Claude world is always there, organized, in one place):

1. Any Ubuntu VM works (a $10–24/mo instance is plenty)
2. Put it on a [Tailscale](https://tailscale.com) network and close every
   public port — SSH over the tailnet only
3. Run this installer on the VM
4. Sync `~/vault/` to their laptop with [Syncthing](https://syncthing.net)
   and open it in Obsidian there

See `docs/ADMIN-SETUP.md` for the checklist and `docs/USER-GUIDE.md` for a
plain-English guide you can hand to the person you're setting this up for.

## What's in the box

```
hub/global-CLAUDE.md              → ~/.claude/CLAUDE.md   (the rulebook)
hub/CLAUDE-KICKOFF/CLAUDE.md      → ~/CLAUDE-KICKOFF/     (the lobby)
hub/templates/new-project/        → ~/templates/          (copied per project)
settings/settings.json            → ~/.claude/settings.json  (optional rails)
docs/                             → guides for the admin and the end user
```

Skill bundles are **not** vendored here — the installer fetches them from
their official repositories, each under its own license.

## License

MIT for everything in this repo.
