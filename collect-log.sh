#!/usr/bin/env bash
# SkyFactory 1.3.2 — collect the game crash log (macOS) for sharing.
# Run this if the game won't launch, then send the file it prints.
set -uo pipefail

OUT="$HOME/Downloads/skyfactory-crash-log.txt"
PROF="$HOME/Library/Application Support/ModrinthApp/profiles"
INSTALL_LOG="$HOME/Downloads/skyfactory-install-log.txt"

{
  echo "===== SkyFactory crash-log bundle ($(date)) ====="
  echo "macOS: $(sw_vers -productVersion 2>/dev/null)  arch: $(uname -m)"
  echo

  echo "----- installer log -----"
  [ -f "$INSTALL_LOG" ] && cat "$INSTALL_LOG" || echo "(none)"
  echo

  newest="$(ls -t "$PROF"/*/logs/*.log 2>/dev/null | head -1)"
  if [ -n "${newest:-}" ]; then
    echo "----- newest game log: $newest -----"
    tail -n 400 "$newest"
  else
    echo "----- no game log found under $PROF -----"
    echo "(launch the instance once so it writes a log, then re-run this)"
  fi
  echo

  # any Forge/Java crash reports + hs_err files
  while IFS= read -r f; do
    [ -f "$f" ] || continue
    echo "----- crash report: $f -----"; cat "$f"; echo
  done < <(ls -t "$PROF"/*/crash-reports/*.txt "$PROF"/*/hs_err_pid*.log 2>/dev/null | head -3)
} > "$OUT" 2>&1

echo "Wrote: $OUT"
echo "Send that file so the launch failure can be diagnosed."
open -R "$OUT" >/dev/null 2>&1 || true
