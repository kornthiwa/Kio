#!/usr/bin/env bash
# Validate note/*/manifest.json under a project root.
# Usage:
#   ./scripts/validate-notes.sh
#   ./scripts/validate-notes.sh /path/to/project
#   ./scripts/validate-notes.sh /path/to/project strict   # also check role frontmatter

set -euo pipefail

TARGET="${1:-$(pwd)}"
STRICT="${2:-}"
TARGET="$(cd "$TARGET" && pwd)"
NOTE_ROOT="$TARGET/note"
fail=0

fail_msg() {
  echo "FAIL  $1" >&2
  fail=$((fail + 1))
}
ok_msg() {
  echo "OK    $1"
}

if [[ ! -d "$NOTE_ROOT" ]]; then
  echo "No note/ under $TARGET — nothing to validate."
  exit 0
fi

echo "Kio validate-notes → $TARGET"
echo ""

shopt -s nullglob
dirs=("$NOTE_ROOT"/*/)
if [[ ${#dirs[@]} -eq 0 ]]; then
  echo "note/ has no topic folders."
  exit 0
fi

for dir in "${dirs[@]}"; do
  name="$(basename "$dir")"
  rel="note/$name"
  mf="$dir/manifest.json"
  if [[ ! -f "$mf" ]]; then
    fail_msg "$rel missing manifest.json"
    continue
  fi
  if ! python3 - "$mf" "$rel" <<'PY'
import json, sys, re
path, rel = sys.argv[1], sys.argv[2]
try:
    m = json.load(open(path, encoding="utf-8"))
except Exception as e:
    print(f"FAIL  {rel}/manifest.json invalid JSON: {e}")
    raise SystemExit(2)
req = ["date", "note_folder", "updated_at", "us_ids", "roles"]
errs = []
for k in req:
    if k not in m:
        errs.append(f"missing {k}")
if "date" in m and not re.match(r"^\d{4}-\d{2}-\d{2}$", str(m["date"])):
    errs.append(f"bad date: {m.get('date')}")
if not isinstance(m.get("us_ids"), list):
    errs.append("us_ids must be an array")
roles = m.get("roles") or {}
for role in ("ba", "sa", "dev", "qa"):
    entry = roles.get(role)
    if not isinstance(entry, dict):
        errs.append(f"roles.{role} missing")
        continue
    if not entry.get("file"):
        errs.append(f"roles.{role}.file missing")
    st = entry.get("status", "MISSING")
    if st is not None and st not in ("draft", "ready", "blocked"):
        errs.append(f"roles.{role}.status invalid: {st}")
rec = m.get("recommendation", None)
if rec is not None and rec not in ("ship", "ship_with_risk", "no_ship"):
    errs.append(f"recommendation invalid: {rec}")
if errs:
    for e in errs:
        print(f"FAIL  {rel}: {e}")
    raise SystemExit(2)
print(f"OK    {rel}/manifest.json parsed")
PY
  then
    if [[ $? -eq 2 ]]; then fail=$((fail + 1)); fi
  fi

  if [[ "$STRICT" == "strict" ]]; then
    for pair in "ba.brief.md:ba" "sa.spec.md:sa" "dev.impl.md:dev" "qa.status.md:qa"; do
      file="${pair%%:*}"
      role="${pair##*:}"
      path="$dir$file"
      [[ -f "$path" ]] || continue
      python3 - "$path" "$role" <<'PY' || fail=$((fail + 1))
import re, sys
path, expected = sys.argv[1], sys.argv[2]
text = open(path, encoding="utf-8").read()
m = re.match(r"\A---\n(.*?)\n---\n", text, re.S)
if not m:
    print(f"FAIL  {path} missing YAML frontmatter")
    raise SystemExit(1)
front = m.group(1)
kv = {}
for line in front.splitlines():
    if ":" in line:
        k, v = line.split(":", 1)
        kv[k.strip()] = v.strip()
for k in ("date", "role", "status", "us_ids", "note_folder"):
    if k not in kv:
        print(f"FAIL  {path} frontmatter missing: {k}")
        raise SystemExit(1)
if kv.get("role") != expected:
    print(f"FAIL  {path} role={kv.get('role')} expected {expected}")
    raise SystemExit(1)
if kv.get("status") not in ("draft", "ready", "blocked"):
    print(f"FAIL  {path} status invalid: {kv.get('status')}")
    raise SystemExit(1)
if not re.match(r"^\d{4}-\d{2}-\d{2}$", kv.get("date", "")):
    print(f"FAIL  {path} date invalid: {kv.get('date')}")
    raise SystemExit(1)
print(f"OK    {path} frontmatter")
PY
    done
  fi
done
shopt -u nullglob

echo ""
echo "Done. fail=$fail"
[[ "$fail" -eq 0 ]]
