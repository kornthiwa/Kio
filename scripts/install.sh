#!/usr/bin/env bash
# Install Kio skills/rules/templates into a project for Cursor and/or Claude Code.
# Usage:
#   ./scripts/install.sh
#   ./scripts/install.sh /path/to/project
#   ./scripts/install.sh /path/to/project both
#   ./scripts/install.sh /path/to/project cursor
#   ./scripts/install.sh /path/to/project claude
#   ./scripts/install.sh /path/to/project both force   # overwrite AGENTS.md / CLAUDE.md

set -euo pipefail

TARGET="${1:-$(pwd)}"
APP="${2:-both}"
FORCE_TEMPLATES="${3:-}"

case "$APP" in
  cursor|claude|both) ;;
  *)
    echo "App must be: cursor | claude | both" >&2
    exit 1
    ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET="$(cd "$TARGET" && pwd)"
SKILLS_SRC="$KIO_ROOT/skills"
RULES_SRC="$KIO_ROOT/rules"
TEMPLATES_SRC="$KIO_ROOT/templates"

ensure_dir() {
  mkdir -p "$1"
}

install_skills() {
  local dest_root="$1"
  local count=0
  ensure_dir "$dest_root"
  shopt -s nullglob
  for dir in "$SKILLS_SRC"/*/; do
    [ -f "${dir}SKILL.md" ] || continue
    name="$(basename "$dir")"
    rm -rf "$dest_root/$name"
    cp -R "$dir" "$dest_root/$name"
    echo "  skill  $name"
    count=$((count + 1))
  done
  shopt -u nullglob
  SKILL_COUNT=$count
}

convert_mdc_to_claude_md() {
  local file="$1"
  python3 - "$file" <<'PY'
import re, sys
path = sys.argv[1]
text = open(path, encoding="utf-8").read()
m = re.match(r"\A---\n(.*?)\n---\n(.*)\Z", text, re.S)
if not m:
    sys.stdout.write(text)
    raise SystemExit
front, body = m.group(1), m.group(2)
desc = None
globs = None
always = False
for line in front.splitlines():
    if line.strip().startswith("description:"):
        desc = line.split(":", 1)[1].strip().strip("\"'")
    elif line.strip().startswith("globs:"):
        globs = line.split(":", 1)[1].strip().strip("\"'")
    elif re.match(r"^\s*alwaysApply:\s*true\s*$", line):
        always = True
out = ["---"]
if desc:
    out.append(f"description: {desc}")
if not always and globs:
    out.append("paths:")
    out.append(f'  - "{globs}"')
out.append("---")
out.append("")
out.append(body.rstrip())
out.append("")
sys.stdout.write("\n".join(out))
PY
}

install_cursor_rules() {
  local dest_root="$1"
  local count=0
  ensure_dir "$dest_root"
  shopt -s nullglob
  for f in "$RULES_SRC"/*.mdc; do
    cp "$f" "$dest_root/$(basename "$f")"
    echo "  rule   $(basename "$f")"
    count=$((count + 1))
  done
  shopt -u nullglob
  RULE_COUNT=$count
}

install_claude_rules() {
  local dest_root="$1"
  local count=0
  ensure_dir "$dest_root"
  if ! command -v python3 >/dev/null 2>&1; then
    echo "  error: python3 required to convert .mdc → Claude .md rules" >&2
    exit 1
  fi
  shopt -s nullglob
  for f in "$RULES_SRC"/*.mdc; do
    name="$(basename "$f" .mdc).md"
    convert_mdc_to_claude_md "$f" > "$dest_root/$name"
    echo "  rule   $name  (from $(basename "$f"))"
    count=$((count + 1))
  done
  shopt -u nullglob
  RULE_COUNT=$count
}

install_template() {
  local file_name="$1"
  local src="$TEMPLATES_SRC/$file_name"
  local dest="$TARGET/$file_name"
  if [[ ! -f "$src" ]]; then
    echo "  skip   $file_name  (template missing)"
    TEMPLATE_COUNT=0
    return
  fi
  if [[ -f "$dest" && "$FORCE_TEMPLATES" != "force" ]]; then
    echo "  skip   $file_name  (exists — pass force to overwrite)"
    TEMPLATE_COUNT=0
    return
  fi
  cp "$src" "$dest"
  echo "  tmpl   $file_name"
  TEMPLATE_COUNT=1
}

install_note_contract() {
  local src="$TEMPLATES_SRC/note"
  local dest="$TARGET/templates/note"
  local count=0
  if [[ ! -d "$src" ]]; then
    echo "  skip   templates/note  (missing)"
    TEMPLATE_COUNT=0
    return
  fi
  ensure_dir "$dest"
  shopt -s nullglob
  for f in "$src"/*; do
    [[ -f "$f" ]] || continue
    cp "$f" "$dest/$(basename "$f")"
    echo "  note   templates/note/$(basename "$f")"
    count=$((count + 1))
  done
  shopt -u nullglob
  TEMPLATE_COUNT=$count
}

echo "Kio install → $TARGET  (app: $APP)"
echo ""

total_skills=0
total_rules=0
total_templates=0

if [[ "$APP" == "cursor" || "$APP" == "both" ]]; then
  echo "[Cursor]"
  ensure_dir "$TARGET/.cursor"
  install_skills "$TARGET/.cursor/skills"
  total_skills=$((total_skills + SKILL_COUNT))
  install_cursor_rules "$TARGET/.cursor/rules"
  total_rules=$((total_rules + RULE_COUNT))
  install_template "AGENTS.md"
  total_templates=$((total_templates + TEMPLATE_COUNT))
  echo ""
fi

if [[ "$APP" == "claude" || "$APP" == "both" ]]; then
  echo "[Claude Code]"
  ensure_dir "$TARGET/.claude"
  install_skills "$TARGET/.claude/skills"
  total_skills=$((total_skills + SKILL_COUNT))
  install_claude_rules "$TARGET/.claude/rules"
  total_rules=$((total_rules + RULE_COUNT))
  install_template "CLAUDE.md"
  total_templates=$((total_templates + TEMPLATE_COUNT))
  echo ""
fi

echo "[Note contract]"
install_note_contract
total_templates=$((total_templates + TEMPLATE_COUNT))
echo ""

echo "Done. skills: $total_skills  |  rules: $total_rules  |  templates: $total_templates"
[[ "$APP" == "cursor" || "$APP" == "both" ]] && echo "  Cursor → .cursor/skills  .cursor/rules  AGENTS.md"
[[ "$APP" == "claude" || "$APP" == "both" ]] && echo "  Claude → .claude/skills  .claude/rules  CLAUDE.md"
echo "  Note   → templates/note/  (manifest + frontmatter schemas)"
