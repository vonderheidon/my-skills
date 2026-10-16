#!/usr/bin/env bash
set -euo pipefail

# Execute dentro do ambiente (host/container) no qual os agentes rodam.
# Sem --apply: simula. Nunca substitui destinos existentes.
MODE="preview"
case "${1:-}" in
  "") ;;
  --apply) MODE="apply" ;;
  *) printf 'Uso: bash scripts/link-skills.sh [--apply]\n' >&2; exit 2 ;;
esac

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
REPO_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"
DESTINATIONS=(
  "$HOME/.codex/skills"
  "$HOME/.claude/skills"
  "$HOME/.config/opencode/skills"
  "$HOME/.agents/skills"
)

count=0
shopt -s nullglob
for skill in "$REPO_DIR"/*/; do
  [[ -f "${skill}SKILL.md" ]] || continue
  name="$(basename -- "$skill")"
  ((count+=1))
  for dest in "${DESTINATIONS[@]}"; do
    target="${dest}/${name}"
    if [[ -e "$target" || -L "$target" ]]; then
      printf 'PRESERVADO: %s (já existe)\n' "$target"
      continue
    fi
    if [[ -e "$dest" && ! -d "$dest" ]]; then
      printf 'IGNORADO: %s não é um diretório\n' "$dest" >&2
      continue
    fi
    if [[ -L "$dest" ]]; then
      printf 'IGNORADO: %s é link simbólico; requer diretório real\n' "$dest" >&2
      continue
    fi
    if [[ "$MODE" == apply ]]; then
      mkdir -p -- "$dest"
      ln -s -- "${skill%/}" "$target"
      printf 'CRIADO: %s -> %s\n' "$target" "${skill%/}"
    else
      printf 'PREVISTO: %s -> %s\n' "$target" "${skill%/}"
    fi
  done
done
if ((count == 0)); then
  printf 'Nenhuma skill encontrada. Nenhuma alteração feita.\n'
fi
