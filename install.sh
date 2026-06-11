#!/usr/bin/env bash
# claude-code-kickstart — plug-and-play Claude Code setup
# Usage:
#   ./install.sh                 # folders + CLAUDE.mds + login greeting
#   ./install.sh --skills all    # also fetch skill bundles (ecc, superpowers, hermes)
#   ./install.sh --skills ecc,superpowers
#   ./install.sh --rails         # also install the safety-rails settings.json
#   ./install.sh --no-bashrc     # skip the login greeting/aliases
set -euo pipefail

SKILLS="none"; RAILS=0; BASHRC=1
for arg in "$@"; do
  case "$arg" in
    --skills) ;; # value handled below
    --skills=*) SKILLS="${arg#*=}" ;;
    all|ecc,*|ecc|superpowers*|hermes*) SKILLS="$arg" ;;
    --rails) RAILS=1 ;;
    --no-bashrc) BASHRC=0 ;;
    -h|--help) grep '^#' "$0" | head -8; exit 0 ;;
  esac
done
[ "$SKILLS" = "all" ] && SKILLS="ecc,superpowers,hermes"

HERE="$(cd "$(dirname "$0")" && pwd)"
say() { printf '\033[1;36m==>\033[0m %s\n' "$*"; }

# 1. Folders
say "Creating hub folders"
mkdir -p ~/CLAUDE-KICKOFF ~/projects ~/templates/new-project \
         ~/vault/{Projects,Inbox,Daily,Reference} ~/.claude/skills

# 2. CLAUDE.md files (back up anything that exists)
say "Installing CLAUDE.md files"
[ -f ~/.claude/CLAUDE.md ] && cp ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.bak.$(date +%s)
cp "$HERE/hub/global-CLAUDE.md"                ~/.claude/CLAUDE.md
cp "$HERE/hub/CLAUDE-KICKOFF/CLAUDE.md"        ~/CLAUDE-KICKOFF/CLAUDE.md
cp "$HERE/hub/templates/new-project/CLAUDE.md" ~/templates/new-project/CLAUDE.md

# 3. Login greeting + aliases (idempotent)
if [ "$BASHRC" = 1 ] && ! grep -q "Claude Hub login experience" ~/.bashrc 2>/dev/null; then
  say "Adding login greeting to ~/.bashrc"
  cat >> ~/.bashrc << 'EOF'

# --- Claude Hub login experience ---
if [[ $- == *i* ]] && [[ -z "${CLAUDE_HUB_GREETED:-}" ]]; then
  export CLAUDE_HUB_GREETED=1
  cd ~/CLAUDE-KICKOFF
  echo ""
  echo "  ███ CLAUDE HUB ███"
  echo ""
  echo "  Type  go  and press Enter to start."
  echo ""
fi
alias go="claude"
# --- end Claude Hub ---
EOF
fi

# 4. Safety rails (only if no settings.json exists — never clobber)
if [ "$RAILS" = 1 ]; then
  if [ -f ~/.claude/settings.json ]; then
    say "SKIPPED rails: ~/.claude/settings.json exists (see settings/settings.json to merge by hand)"
  else
    say "Installing safety-rails settings.json"
    cp "$HERE/settings/settings.json" ~/.claude/settings.json
  fi
fi

# 5. Skill bundles — fetched from their OFFICIAL repos (each has its own license)
fetch_skills() { # $1 repo url, $2 subdir containing skills, $3 label
  local tmp; tmp="$(mktemp -d)"
  say "Fetching $3 skills"
  git clone --depth 1 --quiet "$1" "$tmp"
  local n=0
  while IFS= read -r -d '' s; do
    local name; name="$(basename "$(dirname "$s")")"
    if [ ! -e ~/.claude/skills/"$name" ]; then
      cp -r "$(dirname "$s")" ~/.claude/skills/"$name"; n=$((n+1))
    fi
  done < <(find "$tmp/$2" -name SKILL.md -print0 2>/dev/null)
  rm -rf "$tmp"
  say "$3: $n skills installed"
}
case ",$SKILLS," in *",ecc,"*)
  fetch_skills https://github.com/affaan-m/everything-claude-code skills "Everything-Claude-Code";; esac
case ",$SKILLS," in *",superpowers,"*)
  fetch_skills https://github.com/anthropics/claude-plugins-official plugins/superpowers/skills "Superpowers";; esac
case ",$SKILLS," in *",hermes,"*)
  fetch_skills https://github.com/NousResearch/hermes-agent skills "Hermes";; esac

say "Done. Open a new terminal (or 'source ~/.bashrc'), then type: go"
say "First run: Claude Code will ask you to log in with your claude.ai account."
command -v claude >/dev/null 2>&1 || say "NOTE: Claude Code not found — install it first: curl -fsSL https://claude.ai/install.sh | bash"
