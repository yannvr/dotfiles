#!/usr/bin/env sh
# Lightweight remote/bastion bootstrap (POSIX sh)
# - Does NOT assume macOS or zsh
# - Makes minimal, safe improvements for bash/sh shells
# - Optionally guides running the full installer in remote mode

set -eu

echo "[remote-bootstrap] Starting minimal setup for remote/bastion host"

# Detect OS (best-effort)
OS="unknown"
case "$(uname -s 2>/dev/null || echo unknown)" in
  Linux) OS="linux" ;;
  Darwin) OS="darwin" ;;
  *) OS="unknown" ;;
esac
echo "[remote-bootstrap] OS detected: $OS"

# Detect available shell for login
CURRENT_SHELL="${SHELL:-/bin/sh}"
echo "[remote-bootstrap] Current shell: $CURRENT_SHELL"

# Create minimal bash profile if bash is available (non-destructive append)
if command -v bash >/dev/null 2>&1; then
  BASHRC="$HOME/.bashrc"
  BASHPROFILE="$HOME/.bash_profile"
  echo "[remote-bootstrap] Configuring minimal bash environment…"

  # Ensure files exist
  [ -f "$BASHRC" ] || touch "$BASHRC"
  [ -f "$BASHPROFILE" ] || touch "$BASHPROFILE"

  # Add minimal prompt and safe aliases if not already present
  if ! grep -q "# <dotfiles-remote-bootstrap>" "$BASHRC" 2>/dev/null; then
    {
      echo "# <dotfiles-remote-bootstrap>"
      echo "# Minimal prompt with git branch (if available)"
      echo "parse_git_branch() { git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/^/ (/;s/$/)/'; }"
      echo "export PS1='\u@\h:\w\$(parse_git_branch)\$ '"
      echo "# Safe, helpful aliases"
      echo "alias ll='ls -alF'"
      echo "alias la='ls -A'"
      echo "alias l='ls -CF'"
      echo "alias gs='git status 2>/dev/null || true'"
      echo "alias gd='git diff 2>/dev/null || true'"
      echo "alias grep='grep --color=auto'"
      echo "alias egrep='egrep --color=auto'"
      echo "alias fgrep='fgrep --color=auto'"
      echo "# History quality"
      echo "export HISTCONTROL=ignoredups:erasedups"
      echo "export HISTSIZE=5000"
      echo "export HISTFILESIZE=5000"
      echo "# <dotfiles-remote-bootstrap/>"
    } >> "$BASHRC"
    echo "[remote-bootstrap] Appended minimal bash config to $BASHRC"
  else
    echo "[remote-bootstrap] Bash config already contains remote bootstrap block"
  fi

  # Ensure bashrc loads on login for some environments
  if ! grep -q ".bashrc" "$BASHPROFILE" 2>/dev/null; then
    echo "[ -f \"$BASHRC\" ] && . \"$BASHRC\"" >> "$BASHPROFILE"
    echo "[remote-bootstrap] Ensured $BASHPROFILE sources $BASHRC"
  fi
fi

# If zsh exists, optionally suggest running the full installer in remote mode
if command -v zsh >/dev/null 2>&1; then
  echo "[remote-bootstrap] zsh detected. You can run the full installer in remote mode:"
  echo "    git clone https://github.com/yourusername/dotfiles ~/.dotfiles && \"
  echo "    cd ~/.dotfiles && ./install.sh --remote --yes"
else
  echo "[remote-bootstrap] zsh not found — staying on bash/sh with minimal improvements."
fi

echo "[remote-bootstrap] Ensuring zsh is available (install if missing)…"
if ! command -v zsh >/dev/null 2>&1; then
  # Best-effort package manager detection
  if command -v apt-get >/dev/null 2>&1; then
    (sudo apt-get update -y && sudo apt-get install -y zsh) 2>/dev/null || true
  elif command -v apt >/dev/null 2>&1; then
    (sudo apt update -y && sudo apt install -y zsh) 2>/dev/null || true
  elif command -v dnf >/dev/null 2>&1; then
    (sudo dnf install -y zsh) 2>/dev/null || true
  elif command -v yum >/dev/null 2>&1; then
    (sudo yum install -y zsh) 2>/dev/null || true
  elif command -v apk >/dev/null 2>&1; then
    (sudo apk add --no-cache zsh) 2>/dev/null || true
  elif command -v pacman >/dev/null 2>&1; then
    (sudo pacman -Sy --noconfirm zsh) 2>/dev/null || true
  elif [ "$OS" = "darwin" ] && command -v brew >/dev/null 2>&1; then
    (brew update && brew install zsh) 2>/dev/null || true
  fi
fi

if command -v zsh >/dev/null 2>&1; then
  echo "[remote-bootstrap] zsh is available. To run full remote setup:"
  echo "    git clone https://github.com/yourusername/dotfiles ~/.dotfiles && \"
  echo "    cd ~/.dotfiles && ./install.sh --remote --yes"
else
  echo "[remote-bootstrap] zsh not installed automatically. Install zsh via your package manager and re-run."
fi

echo "[remote-bootstrap] Done. Open a new shell or run: exec \"\$SHELL\""

