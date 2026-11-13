#Requires -Version 5.1
<#
.SYNOPSIS
  Install Kio skills/rules/templates into a project for Cursor and/or Claude Code.
.PARAMETER Target
  Project root. Defaults to current directory.
.PARAMETER App
  cursor | claude | both (default: both)
.PARAMETER ForceTemplates
  Overwrite existing AGENTS.md / CLAUDE.md
#>
param(
  [string]$Target = (Get-Location).Path,
  [ValidateSet("cursor", "claude", "both")]
  [string]$App = "both",
  [switch]$ForceTemplates
)

$ErrorActionPreference = "Stop"

$KioRoot = Split-Path -Parent $PSScriptRoot
$Target = (Resolve-Path -LiteralPath $Target).Path
$skillsSrc = Join-Path $KioRoot "skills"
$rulesSrc = Join-Path $KioRoot "rules"
$templatesSrc = Join-Path $KioRoot "templates"

function Ensure-Dir([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) {
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
  }
}

function Write-Utf8NoBom([string]$Path, [string]$Content) {
  $utf8 = New-Object System.Text.UTF8Encoding $false
  [System.IO.File]::WriteAllText($Path, $Content, $utf8)
}

function Install-Skills([string]$DestRoot) {
  Ensure-Dir $DestRoot
  $count = 0
  foreach ($dir in @(Get-ChildItem -LiteralPath $skillsSrc -Directory -ErrorAction SilentlyContinue)) {
    $skillMd = Join-Path $dir.FullName "SKILL.md"
    if (-not (Test-Path -LiteralPath $skillMd)) { continue }

    $dest = Join-Path $DestRoot $dir.Name
    if (Test-Path -LiteralPath $dest) {
      Remove-Item -LiteralPath $dest -Recurse -Force
    }
    Copy-Item -LiteralPath $dir.FullName -Destination $dest -Recurse -Force
    $count++
    Write-Host "  skill  $($dir.Name)"
  }
  return $count
}

function Convert-MdcToClaudeMd([string]$Content) {
  if ($Content -notmatch '(?s)\A---\r?\n(.*?)\r?\n---\r?\n(.*)\z') {
    return $Content
  }

  $front = $Matches[1]
  $body = $Matches[2]
  $desc = $null
  $globs = $null
  $alwaysApply = $false

  foreach ($line in ($front -split '\r?\n')) {
    if ($line -match '^\s*description:\s*(.*)$') { $desc = $Matches[1].Trim().Trim('"').Trim("'") }
    if ($line -match '^\s*globs:\s*(.*)$') { $globs = $Matches[1].Trim().Trim('"').Trim("'") }
    if ($line -match '^\s*alwaysApply:\s*true\s*$') { $alwaysApply = $true }
  }

  $out = New-Object System.Collections.Generic.List[string]
  [void]$out.Add("---")
  if ($desc) { [void]$out.Add("description: $desc") }
  if (-not $alwaysApply -and $globs) {
    [void]$out.Add("paths:")
    [void]$out.Add("  - `"$globs`"")
  }
  [void]$out.Add("---")
  [void]$out.Add("")
  [void]$out.Add($body.TrimEnd())
  [void]$out.Add("")
  return ($out -join "`n")
}

function Install-CursorRules([string]$DestRoot) {
  Ensure-Dir $DestRoot
  $count = 0
  foreach ($file in @(Get-ChildItem -LiteralPath $rulesSrc -Filter "*.mdc" -File -ErrorAction SilentlyContinue)) {
    Copy-Item -LiteralPath $file.FullName -Destination (Join-Path $DestRoot $file.Name) -Force
    $count++
    Write-Host "  rule   $($file.Name)"
  }
  return $count
}

function Install-ClaudeRules([string]$DestRoot) {
  Ensure-Dir $DestRoot
  $count = 0
  foreach ($file in @(Get-ChildItem -LiteralPath $rulesSrc -Filter "*.mdc" -File -ErrorAction SilentlyContinue)) {
    $raw = [System.IO.File]::ReadAllText($file.FullName)
    $converted = Convert-MdcToClaudeMd $raw
    $name = [System.IO.Path]::GetFileNameWithoutExtension($file.Name) + ".md"
    Write-Utf8NoBom (Join-Path $DestRoot $name) $converted
    $count++
    Write-Host "  rule   $name  (from $($file.Name))"
  }
  return $count
}

function Install-Template([string]$FileName) {
  $src = Join-Path $templatesSrc $FileName
  if (-not (Test-Path -LiteralPath $src)) {
    Write-Host "  skip   $FileName  (template missing)"
    return 0
  }
  $dest = Join-Path $Target $FileName
  if ((Test-Path -LiteralPath $dest) -and -not $ForceTemplates) {
    Write-Host "  skip   $FileName  (exists — use -ForceTemplates to overwrite)"
    return 0
  }
  Copy-Item -LiteralPath $src -Destination $dest -Force
  Write-Host "  tmpl   $FileName"
  return 1
}

function Install-NoteContract {
  $src = Join-Path $templatesSrc "note"
  if (-not (Test-Path -LiteralPath $src)) {
    Write-Host "  skip   templates/note  (missing)"
    return 0
  }
  $dest = Join-Path $Target "templates\note"
  Ensure-Dir $dest
  $count = 0
  foreach ($file in @(Get-ChildItem -LiteralPath $src -File -ErrorAction SilentlyContinue)) {
    Copy-Item -LiteralPath $file.FullName -Destination (Join-Path $dest $file.Name) -Force
    Write-Host "  note   templates/note/$($file.Name)"
    $count++
  }
  return $count
}

Write-Host "Kio install → $Target  (app: $App)"
Write-Host ""

$totalSkills = 0
$totalRules = 0
$totalTemplates = 0

if ($App -eq "cursor" -or $App -eq "both") {
  Write-Host "[Cursor]"
  Ensure-Dir (Join-Path $Target ".cursor")
  $totalSkills += Install-Skills (Join-Path $Target ".cursor\skills")
  $totalRules += Install-CursorRules (Join-Path $Target ".cursor\rules")
  $totalTemplates += Install-Template "AGENTS.md"
  Write-Host ""
}

if ($App -eq "claude" -or $App -eq "both") {
  Write-Host "[Claude Code]"
  Ensure-Dir (Join-Path $Target ".claude")
  $totalSkills += Install-Skills (Join-Path $Target ".claude\skills")
  $totalRules += Install-ClaudeRules (Join-Path $Target ".claude\rules")
  $totalTemplates += Install-Template "CLAUDE.md"
  Write-Host ""
}

Write-Host "[Note contract]"
$totalTemplates += Install-NoteContract
Write-Host ""

Write-Host "Done. skills: $totalSkills  |  rules: $totalRules  |  templates: $totalTemplates"
if ($App -eq "cursor" -or $App -eq "both") {
  Write-Host "  Cursor → .cursor/skills  .cursor/rules  AGENTS.md"
}
if ($App -eq "claude" -or $App -eq "both") {
  Write-Host "  Claude → .claude/skills  .claude/rules  CLAUDE.md"
}
Write-Host "  Note   → templates/note/  (manifest + frontmatter schemas)"
