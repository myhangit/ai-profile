# 把 AGENTS.md 同步到各 AI 工具的"全局规则"位置
# 用法：在仓库目录里执行  pwsh -File sync.ps1

$ErrorActionPreference = 'Stop'

$root   = Split-Path -Parent $MyInvocation.MyCommand.Path
$source = Join-Path $root 'AGENTS.md'

if (-not (Test-Path $source)) { throw "找不到 $source" }

$targets = @(
    @{ Tool = 'Codex CLI';       Path = Join-Path $env:USERPROFILE '.codex\AGENTS.md' },
    @{ Tool = 'Claude Code';     Path = Join-Path $env:USERPROFILE '.claude\CLAUDE.md' },
    @{ Tool = 'VS Code Copilot'; Path = Join-Path $env:USERPROFILE '.copilot\copilot-instructions.md' },
    @{ Tool = 'Trae';            Path = Join-Path $env:USERPROFILE '.trae\user_rules\user_rules.md' }
)

foreach ($t in $targets) {
    $dir = Split-Path -Parent $t.Path
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

    if (Test-Path $t.Path) {
        $item = Get-Item $t.Path -Force
        if ($item.LinkType) {
            # 已经是链接，删掉重建
            Remove-Item $t.Path -Force
        } else {
            # 是真实文件：保留一份备份，避免丢掉旧内容
            $bak = "$($t.Path).bak"
            if (-not (Test-Path $bak)) { Move-Item $t.Path $bak }
            else { Remove-Item $t.Path -Force }
        }
    }

    try {
        New-Item -ItemType SymbolicLink -Path $t.Path -Target $source | Out-Null
        Write-Host "[链接] $($t.Tool) -> $($t.Path)"
    }
    catch {
        Copy-Item $source $t.Path -Force
        Write-Host "[复制] $($t.Tool) -> $($t.Path)   (无权限建软链，已改为复制)"
    }
}

Write-Host ""
Write-Host "完成。改了 AGENTS.md 后重跑本脚本即可。"
Write-Host "Cursor 的个人规则是纯文本框，需手动粘贴一次：Cursor 设置 > Rules > User Rules"
