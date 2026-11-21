# 把 AGENTS.md 同步到各 AI 工具的"个人级规则"位置
# 用法：pwsh -File sync.ps1
# 有权限就建软链接（改一处全部生效），没权限退化为硬链接，再不行就复制。

$ErrorActionPreference = 'Stop'

$root   = Split-Path -Parent $MyInvocation.MyCommand.Path
$source = Join-Path $root 'AGENTS.md'
if (-not (Test-Path -LiteralPath $source)) { throw "找不到 $source" }

$targets = [ordered]@{
    'Codex CLI'       = Join-Path $env:USERPROFILE '.codex\AGENTS.md'
    'Claude Code'     = Join-Path $env:USERPROFILE '.claude\CLAUDE.md'
    'VS Code Copilot' = Join-Path $env:USERPROFILE '.copilot\copilot-instructions.md'
    'Trae'            = Join-Path $env:USERPROFILE '.trae\user_rules\user_rules.md'
}

$text = Get-Content -LiteralPath $source -Raw

foreach ($tool in $targets.Keys) {
    $dest = $targets[$tool]
    $dir  = Split-Path -Parent $dest
    if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

    if (Test-Path -LiteralPath $dest) {
        $item = Get-Item -LiteralPath $dest -Force
        if ($item.LinkType) {
            Remove-Item -LiteralPath $dest -Force
        }
        elseif ($item.Length -gt 0) {
            $bak = "$dest.bak"
            if (-not (Test-Path -LiteralPath $bak)) { Move-Item -LiteralPath $dest -Destination $bak }
            else { Remove-Item -LiteralPath $dest -Force }
        }
        else {
            Remove-Item -LiteralPath $dest -Force
        }
    }

    # 先试软链接，成功后按实际结果判定模式（不同系统版本可能创建成功但仍报错，所以只看结果）
    $ErrorActionPreference = 'SilentlyContinue'
    New-Item -ItemType SymbolicLink -Path $dest -Target $source | Out-Null
    $ErrorActionPreference = 'Stop'
    $now = if (Test-Path -LiteralPath $dest) { Get-Item -LiteralPath $dest -Force } else { $null }

    if ($now -and $now.LinkType -eq 'SymbolicLink') {
        $mode = '软链接'
    }
    else {
        if ($now) { Remove-Item -LiteralPath $dest -Force }
        $ErrorActionPreference = 'SilentlyContinue'
        New-Item -ItemType HardLink -Path $dest -Target $source | Out-Null
        $ErrorActionPreference = 'Stop'
        $now = if (Test-Path -LiteralPath $dest) { Get-Item -LiteralPath $dest -Force } else { $null }
        if ($now -and $now.LinkType -eq 'HardLink') {
            $mode = '硬链接'
        }
        else {
            if ($now) { Remove-Item -LiteralPath $dest -Force }
            [System.IO.File]::WriteAllText($dest, $text, (New-Object System.Text.UTF8Encoding($false)))
            $mode = '复制'
        }
    }
    Write-Host ("[{0}] {1} -> {2}" -f $mode, $tool, $dest)
}

Write-Host ''
Write-Host '完成。改了 AGENTS.md 后重跑本脚本即可。'
Write-Host 'Cursor 个人规则是纯文本框，需手动粘贴一次：Cursor 设置 > Rules > User Rules'
