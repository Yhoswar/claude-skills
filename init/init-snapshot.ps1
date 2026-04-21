#!/usr/bin/env pwsh
# init-snapshot.ps1 — Crea snapshot de configuración Claude Code

param(
    [string]$SnapshotName = (Get-Date -Format "yyyy-MM-dd"),
    [switch]$IncludeSessions = $false,
    [switch]$IncludeMemories = $false,
    [switch]$Auto = $false
)

$ErrorActionPreference = "Stop"

# Configuración
$SourceDir = "$env:USERPROFILE\.claude"
$MemDir = "$env:USERPROFILE\.claude-mem"
$SnapshotDir = "$PSScriptRoot\..\init-snapshots\$SnapshotName"
$RepoDir = "$PSScriptRoot\.."

Write-Host "📸 Creando snapshot: $SnapshotName" -ForegroundColor Cyan
Write-Host "   Origen: $SourceDir" -ForegroundColor Gray
Write-Host "   Destino: $SnapshotDir" -ForegroundColor Gray
Write-Host ""

# Crear directorio
New-Item -ItemType Directory -Force -Path $SnapshotDir | Out-Null

# 1. Copiar CLAUDE.md
Write-Host "   → Copiando CLAUDE.md..." -NoNewline
Copy-Item "$SourceDir\CLAUDE.md" "$SnapshotDir\CLAUDE.md" -Force
Write-Host " OK" -ForegroundColor Green

# 2. Copiar settings.json
Write-Host "   → Copiando settings.json..." -NoNewline
Copy-Item "$SourceDir\settings.json" "$SnapshotDir\settings.json" -Force
Write-Host " OK" -ForegroundColor Green

# 3. Copiar skills
Write-Host "   → Copiando skills ($((Get-ChildItem $SourceDir\skills -Directory).Count) skills)..." -NoNewline
Copy-Item "$SourceDir\skills" "$SnapshotDir\skills" -Recurse -Force
Write-Host " OK" -ForegroundColor Green

# 4. Copiar agents
Write-Host "   → Copiando agents ($((Get-ChildItem $SourceDir\agents -Directory).Count) agentes)..." -NoNewline
Copy-Item "$SourceDir\agents" "$SnapshotDir\agents" -Recurse -Force
Write-Host " OK" -ForegroundColor Green

# 5. Opcional: sessions
if ($IncludeSessions) {
    Write-Host "   → Copiando projects/sessions..." -NoNewline
    Copy-Item "$SourceDir\projects" "$SnapshotDir\projects" -Recurse -Force
    Write-Host " OK" -ForegroundColor Green
}

# 6. Opcional: memories
if ($IncludeMemories -and (Test-Path $MemDir)) {
    Write-Host "   → Copiando claude-mem..." -NoNewline
    Copy-Item "$MemDir" "$SnapshotDir\claude-mem" -Recurse -Force
    Write-Host " OK" -ForegroundColor Green
}

# 7. Listar MCPs instalados
Write-Host "   → Detectando MCPs..." -NoNewline
$MCPList = @{}
$LocalBin = "$env:USERPROFILE\.local\bin"
if (Test-Path $LocalBin) {
    $Executables = Get-ChildItem $LocalBin -Filter "*-mcp*" -ErrorAction SilentlyContinue
    foreach ($exe in $Executables) {
        $MCPList[$exe.Name] = @{
            path = $exe.FullName
            size = $exe.Length
        }
    }
}
$MCPList | ConvertTo-Json -Depth 3 | Set-Content "$SnapshotDir\mcps-installed.json"
Write-Host " OK ($($MCPList.Count) encontrados)" -ForegroundColor Green

# 8. Generar metadata
$Metadata = @{
    created = Get-Date -Format "o"
    hostname = $env:COMPUTERNAME
    user = $env:USERNAME
    claudeVersion = (claude --version 2>$null) -replace ".*version\s*", ""
    skillsCount = (Get-ChildItem $SourceDir\skills -Directory).Count
    agentsCount = (Get-ChildItem $SourceDir\agents -Directory).Count
    mcpsCount = $MCPList.Count
    includeSessions = $IncludeSessions
    includeMemories = $IncludeMemories
}
$Metadata | ConvertTo-Json -Depth 3 | Set-Content "$SnapshotDir\metadata.json"

Write-Host ""
Write-Host "✅ Snapshot creado en: $SnapshotDir" -ForegroundColor Green

# 9. Actualizar "current" symlink
Write-Host "   → Actualizando 'current'..." -NoNewline
$CurrentLink = "$RepoDir\init-snapshots\current"
if (Test-Path $CurrentLink) {
    Remove-Item $CurrentLink -Force
}
New-Item -ItemType Junction -Path $CurrentLink -Target $SnapshotDir | Out-Null
Write-Host " OK" -ForegroundColor Green

# 10. Git commit (si no es auto)
if (-not $Auto) {
    Write-Host ""
    Write-Host "📝 Git commit..." -NoNewline
    Set-Location $RepoDir
    git add init-snapshots/
    git commit -m "Snapshot $SnapshotName — $($Metadata.skillsCount) skills, $($Metadata.agentsCount) agents" | Out-Null
    Write-Host " OK" -ForegroundColor Green

    $Push = Read-Host "¿Push a GitHub? (s/N)"
    if ($Push -eq 's' -or $Push -eq 'S') {
        git push origin main
        Write-Host "   → Push completado" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "🎉 Snapshot '$SnapshotName' listo para restaurar" -ForegroundColor Cyan
Write-Host "   Para restaurar en otra PC: /init restore" -ForegroundColor Gray
