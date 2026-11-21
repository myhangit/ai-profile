# AI 个人档案

一份可以给我用到的所有 AI 编程工具读取的个人规则库。改一次，全部工具生效，不用每个工具重新介绍一遍我的编码风格和要求。

## 结构

```
ai-profile/
├─ AGENTS.md        ← 唯一主文件，规则全写这里（通用标准，20+ 工具原生支持）
├─ sync.ps1         ← 一键同步到各工具的个人级位置
└─ project-kit/     ← 需要项目级规则时，把里面的文件拷进项目根目录
   ├─ AGENTS.md
   ├─ .github/copilot-instructions.md
   ├─ .cursor/rules/profile.mdc
   └─ .trae/rules/project_rules.md
```

## 各工具读取哪里

| 工具 | 个人级（全局） | 项目级 |
| --- | --- | --- |
| OpenAI Codex | `~/.codex/AGENTS.md` | 仓库根 `AGENTS.md` |
| Claude Code | `~/.claude/CLAUDE.md` | `CLAUDE.md` |
| VS Code / Copilot | `~/.copilot/copilot-instructions.md` | `AGENTS.md` 或 `.github/copilot-instructions.md` |
| Cursor | 设置里的 User Rules（纯文本，需粘贴） | 根 `AGENTS.md` 或 `.cursor/rules/*.mdc` |
| Trae | `~/.trae/user_rules/user_rules.md` | `.trae/rules/project_rules.md` |
| 豆包 / WorkBuddy 等对话类 | 个人偏好 / 长期记忆里粘一段 | 对话里贴 raw 链接 |

表里的 `~` = `C:\Users\Administrator`。

## 用法

1. 改 `AGENTS.md`（这是唯一需要维护的文件）。
2. 跑 `pwsh -File sync.ps1`，把内容写到上表的个人级位置。能建软链就建软链，没权限就自动复制，改动后重跑一次即可。
3. Cursor 个人规则只支持粘贴，手动粘一次。
4. 某个项目想在规则里带上说明，就把 `project-kit/` 里的文件拷到项目根目录。
5. 改完把 `OWNER` 全局替换成你的 GitHub 用户名。

## 上线到 GitHub

```powershell
& "C:\PROGRA~1\Git\cmd\git.exe" init -b main
& "C:\PROGRA~1\Git\cmd\git.exe" add .
& "C:\PROGRA~1\Git\cmd\git.exe" commit -m "feat: 初始化个人 AI 档案"
& "C:\PROGRA~1\Git\cmd\git.exe" remote add origin https://github.com/OWNER/ai-profile.git
& "C:\PROGRA~1\Git\cmd\git.exe" push -u origin main
```

推完后这个链接就是给各种 AI 用的统一入口：

```
https://raw.githubusercontent.com/OWNER/ai-profile/main/AGENTS.md
```

## 改了规则不生效怎么办

- 先确认工具读的是"个人级"还是"项目级"：项目里有 `AGENTS.md` 时，项目级优先。
- Codex / Claude 重启会话才重新读文件。
- 目录结构别动 `AGENTS.md` 的文件名，这是标准名，改名就失效。
