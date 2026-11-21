# AI 个人档案

我的 AI 编程工具共用的一套规则。改一次，全部工具生效，不用每个工具重新介绍一遍我的编码风格和要求。

- 主文件：`AGENTS.md`
- 在线地址：https://raw.githubusercontent.com/myhangit/ai-profile/main/AGENTS.md

## 仓库里有什么

```
ai-profile/
├─ AGENTS.md        ← 唯一主文件，规则全写这里（通用标准，20+ 工具原生支持）
├─ sync.ps1         ← 一键同步到各工具的个人级位置
├─ .gitattributes   ← 统一换行符
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
| 豆包 / WorkBuddy 等对话类 | 个人偏好或对话里贴上面那个在线地址 | — |

表里的 `~` = `C:\Users\Administrator`。

## 怎么用

1. 改 `AGENTS.md`，这是唯一需要维护的文件。
2. 跑同步，把新规则写到上表的个人级位置：

```powershell
pwsh -File C:\Users\Administrator\DoubaoWork\chats\2026-11-21\new-chat\ai-profile\sync.ps1
```

能建软链接就建软链接（改一处全部生效），没有权限会自动改成复制，改动后重跑一次即可。

3. Cursor 个人规则只支持粘贴：Cursor 设置 > Rules > User Rules，把 `AGENTS.md` 内容粘进去一次。
4. 某个项目想要规则说明，把 `project-kit/` 里的文件拷到项目根目录。
5. 换电脑：先 clone，再跑 `sync.ps1`。

```powershell
git clone https://github.com/myhangit/ai-profile.git
```

## 改了规则不生效怎么办

- 先确认工具读的是"个人级"还是"项目级"：项目里有 `AGENTS.md` 时，项目级优先。
- Codex / Claude 要重启会话才会重新读文件。
- 不要改 `AGENTS.md` 这个文件名，这是行业标准名，改名就失效。
