#Requires -Version 5.1
<#
.SYNOPSIS
  Validate note/*/manifest.json (+ optional role frontmatter) under a project root.
.PARAMETER Target
  Project root that contains note/. Defaults to current directory.
.PARAMETER StrictFrontmatter
  Also require YAML frontmatter on present ba.brief.md / sa.spec.md / dev.impl.md / qa.status.md
#>
param(
  [string]$Target = (Get-Location).Path,
  [switch]$StrictFrontmatter
)

$ErrorActionPreference = "Stop"
$Target = (Resolve-Path -LiteralPath $Target).Path
$noteRoot = Join-Path $Target "note"
$fail = 0
$ok = 0

function Fail([string]$Msg) {
  Write-Host "FAIL  $Msg" -ForegroundColor Red
  $script:fail++
}
function Pass([string]$Msg) {
  Write-Host "OK    $Msg"
  $script:ok++
}

function Test-ManifestObject($m, [string]$PathLabel) {
  $before = $script:fail
  foreach ($req in @("date", "note_folder", "updated_at", "us_ids", "roles")) {
    if (-not ($m.PSObject.Properties.Name -contains $req)) {
      Fail "$PathLabel missing required field: $req"
    }
  }
  if ($m.PSObject.Properties.Name -contains "date" -and $m.date -notmatch '^\d{4}-\d{2}-\d{2}$') {
    Fail "$PathLabel bad date: $($m.date)"
  }
  if ($null -eq $m.us_ids -or $m.us_ids -isnot [System.Array]) {
    # ConvertFrom-Json: empty JSON array becomes Object[] — single-element may be unwrapped; accept IEnumerable-ish via @()
    if ($null -eq $m.us_ids) { Fail "$PathLabel us_ids must be an array" }
  }
  if ($null -eq $m.roles) {
    Fail "$PathLabel roles missing"
  } else {
    foreach ($role in @("ba", "sa", "dev", "qa")) {
      $entry = $m.roles.$role
      if ($null -eq $entry) {
        Fail "$PathLabel roles.$role missing"
        continue
      }
      if (-not $entry.file) { Fail "$PathLabel roles.$role.file missing" }
      $st = $entry.status
      if ($null -ne $st -and $st -notin @("draft", "ready", "blocked")) {
        Fail "$PathLabel roles.$role.status invalid: $st"
      }
    }
  }
  if ($null -ne $m.recommendation -and $m.recommendation -notin @("ship", "ship_with_risk", "no_ship")) {
    Fail "$PathLabel recommendation invalid: $($m.recommendation)"
  }
  return ($script:fail -eq $before)
}

function Test-Frontmatter([string]$FilePath, [string]$ExpectedRole) {
  if (-not (Test-Path -LiteralPath $FilePath)) { return }
  $raw = [System.IO.File]::ReadAllText($FilePath)
  if ($raw -notmatch '(?s)\A---\r?\n(.*?)\r?\n---\r?\n') {
    Fail "$FilePath missing YAML frontmatter"
    return
  }
  $front = $Matches[1]
  $map = @{}
  foreach ($line in ($front -split '\r?\n')) {
    if ($line -match '^\s*([A-Za-z0-9_]+)\s*:\s*(.*)$') {
      $map[$Matches[1]] = $Matches[2].Trim()
    }
  }
  foreach ($k in @("date", "role", "status", "us_ids", "note_folder")) {
    if (-not $map.ContainsKey($k)) { Fail "$FilePath frontmatter missing: $k" }
  }
  if ($map["role"] -ne $ExpectedRole) {
    Fail "$FilePath role=$($map['role']) expected $ExpectedRole"
  }
  if ($map["status"] -notin @("draft", "ready", "blocked")) {
    Fail "$FilePath status invalid: $($map['status'])"
  }
  if ($map["date"] -notmatch '^\d{4}-\d{2}-\d{2}$') {
    Fail "$FilePath date invalid: $($map['date'])"
  }
}

if (-not (Test-Path -LiteralPath $noteRoot)) {
  Write-Host "No note/ under $Target — nothing to validate."
  exit 0
}

Write-Host "Kio validate-notes → $Target"
Write-Host ""

$dirs = @(Get-ChildItem -LiteralPath $noteRoot -Directory -ErrorAction SilentlyContinue)
if ($dirs.Count -eq 0) {
  Write-Host "note/ has no topic folders."
  exit 0
}

foreach ($dir in $dirs) {
  $rel = "note/$($dir.Name)"
  $manifestPath = Join-Path $dir.FullName "manifest.json"
  if (-not (Test-Path -LiteralPath $manifestPath)) {
    Fail "$rel missing manifest.json"
  } else {
    try {
      $m = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
      if (Test-ManifestObject $m $rel) {
        Pass "$rel/manifest.json"
      }
    } catch {
      Fail "$rel/manifest.json invalid JSON: $($_.Exception.Message)"
    }
  }

  if ($StrictFrontmatter) {
    Test-Frontmatter (Join-Path $dir.FullName "ba.brief.md") "ba"
    Test-Frontmatter (Join-Path $dir.FullName "sa.spec.md") "sa"
    Test-Frontmatter (Join-Path $dir.FullName "dev.impl.md") "dev"
    Test-Frontmatter (Join-Path $dir.FullName "qa.status.md") "qa"
  }
}

Write-Host ""
Write-Host "Done. ok≈$ok  fail=$fail"
if ($fail -gt 0) { exit 1 } else { exit 0 }
