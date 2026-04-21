#!/usr/bin/env pwsh
# init-restore.ps1 — Restaura configuración Claude Code desde snapshot

param(
    [string]$SnapshotName = "current",
    [switch]$Force = $false,
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"

# Configuración
$RepoDir = "$PSScriptRoot\.."
$SnapshotDir = "$RepoDir\init-snapshots\$SnapshotName"
$TargetDir = "$env:USERPROFILE\.claude"

Write-Host "🔧 Restaurando Claude Code desde: $SnapshotName" -ForegroundColor Cyan
Write-Host ""

# Verificar snapshot existe
if (-not (Test-Path $SnapshotDir)) {
    Write-Error "❌ Snapshot '$SnapshotName' no encontrado en: $SnapshotDir"
    Write-Host "   Disponibles:" -ForegroundColor Yellow
    Get-ChildItem "$RepoDir\init-snapshots" -Directory | ForEach-Object {
        Write-Host "     - $($_.Name)" -ForegroundColor Gray
    }
    exit 1
}

# Leer metadata
$MetadataPath = "$SnapshotDir\metadata.json"
if (Test-Path $MetadataPath) {
    $Metadata = Get-Content $MetadataPath | ConvertFrom-Json
    Write-Host "📊 Snapshot info:" -ForegroundColor Cyan
    Write-Host "   Creado: $($Metadata.created)" -ForegroundColor Gray
    Write-Host "   PC: $($Metadata.hostname)" -ForegroundColor Gray
    Write-Host "   Skills: $($Metadata.skillsCount)" -ForegroundColor Gray
    Write-Host "   Agents: $($Metadata.agentsCount)" -ForegroundColor Gray
    Write-Host "   MCPs: $($Metadata.mcpsCount)" -ForegroundColor Gray
    Write-Host ""
}

# Verificar Claude Code instalado
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Error "❌ Claude Code no está instalado. Instala primero: npm install -g @anthropic-ai/claude-code"
    exit 1
}

# Backup de config actual (si existe)
if (Test-Path $TargetDir) {
    $BackupDir = "$env:USERPROFILE\.claude.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    if (-not $DryRun) {
        Write-Host "💾 Backup de config actual: $BackupDir" -ForegroundColor Yellow
        Copy-Item $TargetDir $BackupDir -Recurse -Force
    } else {
        Write-Host "[DRY-RUN] Se haría backup a: $BackupDir" -ForegroundColor Gray
    }
}

if (-not $Force -and -not $DryRun) {
    $Confirm = Read-Host "¿Sobrescribir configuración actual? (s/N)"
    if ($Confirm -ne 's' -and $Confirm -ne 'S') {
        Write-Host "❌ Cancelado por usuario" -ForegroundColor Yellow
        exit 0
    }
}

# Crear directorio destino
if (-not $DryRun) {
    New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
}

# Copiar archivos
$FilesToCopy = @(
    @{ Source = "CLAUDE.md"; Target = "CLAUDE.md"; Required = $true },
    @{ Source = "settings.json"; Target = "settings.json"; Required = $true },
    @{ Source = "skills"; Target = "skills"; Required = $true },
    @{ Source = "agents"; Target = "agents"; Required = $true }
)

foreach ($file in $FilesToCopy) {
    $Src = "$SnapshotDir\$($file.Source)"
    $Dst = "$TargetDir\$($file.Target)"

    if (-not (Test-Path $Src)) {
        if ($file.Required) {
            Write-Warning "⚠️  $($file.Source) no encontrado en snapshot"
        }
        continue
    }

    Write-Host "   → $($file.Source)..." -NoNewline

    if ($DryRun) {
        Write-Host " [DRY-RUN]" -ForegroundColor Gray
    } else {
        if (Test-Path $Dst) {
            Remove-Item $Dst -Recurse -Force
        }
        Copy-Item $Src $Dst -Recurse -Force
        Write-Host " OK" -ForegroundColor Green
    }
}

# Restaurar projects (opcional)
$ProjectsSrc = "$SnapshotDir\projects"
if (Test-Path $ProjectsSrc) {
    Write-Host "   → projects/ (opcional)..." -NoNewline
    if ($RestoreProjects -eq 's' -or $RestoreProjects -eq 'S' -or $DryRun) {
        if (-not $DryRun) {
            Copy-Item $ProjectsSrc "$TargetDir\projects" -Recurse -Force
        }
        Write-Host " OK" -ForegroundColor Green
    } else {
        Write-Host " Omitido" -ForegroundColor Gray
    }
}

# Verificar MCPs
$MCPFile = "$SnapshotDir\mcps-installed.json"
if (Test-Path $MCPFile) {
    Write-Host ""
    Write-Host "🔌 MCPs detectados en snapshot:" -ForegroundColor Cyan
    $MCPs = Get-Content $MCPFile | ConvertFrom-Json

    foreach ($mcp in $MCPs.PSObject.Properties) {
        $Installed = Test-Path "$env:USERPROFILE\.local\bin\$($mcp.Name)"
        $Status = if ($Installed) { "✅" } else { "❌" }
        Write-Host "   $Status $($mcp.Name)" -ForegroundColor $(if ($Installed) { "Green" } else { "Yellow" })
    }

    Write-Host ""
    Write-Host "⚠️  Nota: Reinstala los MCPs manualmente desde sus repos oficiales" -ForegroundColor Yellow
}

Write-Host ""
if ($DryRun) {
    Write-Host "🔍 [DRY-RUN] Simulación completada. Nada se modificó." -ForegroundColor Cyan
} else {
    Write-Host "✅ Restauración completada" -ForegroundColor Green
    Write-Host ""
    Write-Host "🚀 Próximos pasos:" -ForegroundColor Cyan
    Write-Host "   1. Verificar Google Drive sincronizado" -ForegroundColor Gray
    Write-Host "   2. Ejecutar: claude" -ForegroundColor Gray
    Write-Host "   3. Probar: /status" -ForegroundColor Gray
}
