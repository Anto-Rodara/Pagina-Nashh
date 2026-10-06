$ErrorActionPreference = "Stop"
$repoPath = $PSScriptRoot
$quietSeconds = 4
$retrySeconds = 60

function Write-SyncLog {
    param([string]$Message)

    Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
}

function Invoke-Git {
    param(
        [string[]]$GitArgs,
        [int[]]$AllowedExitCodes = @(0)
    )

    $output = & git -C $repoPath @GitArgs 2>&1
    $exitCode = $LASTEXITCODE
    foreach ($line in $output) {
        Write-Host $line
    }

    if ($AllowedExitCodes -notcontains $exitCode) {
        throw "git $($GitArgs -join ' ') falló (código $exitCode)."
    }

    return $exitCode
}

function Get-FileSnapshot {
    $files = Get-ChildItem -LiteralPath $repoPath -File -Recurse -Force |
        Where-Object { $_.FullName -notmatch '[\\/]\.git([\\/]|$)' } |
        ForEach-Object {
            $relativePath = $_.FullName.Substring($repoPath.Length).ToLowerInvariant()
            "$relativePath|$($_.Length)|$($_.LastWriteTimeUtc.Ticks)"
        }

    return ($files | Sort-Object) -join "`n"
}

function Sync-Repository {
    Invoke-Git -GitArgs @("add", "--all") | Out-Null
    $hasStagedChanges = Invoke-Git -GitArgs @("diff", "--cached", "--quiet") -AllowedExitCodes @(0, 1)

    if ($hasStagedChanges -eq 1) {
        Invoke-Git -GitArgs @(
            "commit",
            "-m", "Auto-sync website updates",
            "-m", "Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
        ) | Out-Null
    }

    $upstream = (& git -C $repoPath rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>&1 | Out-String).Trim()
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($upstream)) {
        throw "No se encontró una rama remota de seguimiento. Configura el upstream de main."
    }

    $aheadCount = (& git -C $repoPath rev-list --count "${upstream}..HEAD" 2>&1 | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) {
        throw "No se pudo comprobar si hay commits pendientes para subir."
    }

    if ([int]$aheadCount -gt 0) {
        Invoke-Git -GitArgs @("push", "origin", "main") | Out-Null
        Write-SyncLog "Cambios enviados a GitHub. Netlify los publicará si el repositorio está conectado."
    }
    else {
        Write-SyncLog "GitHub ya está actualizado."
    }
}

Write-SyncLog "Iniciando sincronización automática de $repoPath."
Write-SyncLog "Se agruparán los cambios tras $quietSeconds segundos sin ediciones."

$lastSnapshot = Get-FileSnapshot
$pendingSince = $null
$lastSync = (Get-Date).AddSeconds(-$retrySeconds)
Write-SyncLog "Sincronización automática activa."

while ($true) {
    Start-Sleep -Seconds 2
    $currentSnapshot = Get-FileSnapshot

    if ($currentSnapshot -ne $lastSnapshot) {
        $lastSnapshot = $currentSnapshot
        $pendingSince = Get-Date
        Write-SyncLog "Se detectaron cambios; esperando a que terminen las ediciones."
    }

    $quietPeriodElapsed = $pendingSince -and ((Get-Date) - $pendingSince).TotalSeconds -ge $quietSeconds
    $retryPeriodElapsed = ((Get-Date) - $lastSync).TotalSeconds -ge $retrySeconds

    if ($quietPeriodElapsed -or $retryPeriodElapsed) {
        try {
            Sync-Repository
        }
        catch {
            Write-SyncLog "Error de sincronización: $($_.Exception.Message)"
            Write-SyncLog "Se volverá a intentar al detectar cambios o dentro de $retrySeconds segundos."
        }

        $pendingSince = $null
        $lastSync = Get-Date
    }
}
