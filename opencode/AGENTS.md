# OPENCODE AI CONFIG

OpenCode terminal AI assistant configuration with custom agents, model routing, and skills.

## STRUCTURE

```
opencode/.config/opencode/
├── opencode.json       # Main config (plugins, MCP servers, formatters)
├── oh-my-opencode.json # Agent/category model assignments
├── agents/             # Custom agent definitions
│   └── momus-code-reviewer.md
└── skills/             # Injected workflows
    └── code-review.md
```

## WHERE TO LOOK

| Task | Location |
|------|----------|
| Change default models | `oh-my-opencode.json` → `agents` or `categories` |
| Add MCP server | `opencode.json` → `mcp` |
| Create custom agent | `agents/<name>.md` |
| Create skill/workflow | `skills/<name>.md` |

## KEY CONFIGS

**Plugins**: `oh-my-opencode`, `opencode-gemini-auth`

**MCP Servers**:
- `playwright` (local) - Browser automation
- `cloudflare` (remote, disabled)
- `crawl4ai` (remote, disabled)

**Formatters**: `ruff` for Python

## AGENTS (oh-my-opencode.json)

| Agent | Model | Purpose |
|-------|-------|---------|
| sisyphus | claude-opus-4.5 | Main orchestrator |
| oracle | gpt-5.2 | High-IQ consultation |
| explore | grok-code-fast-1 | Codebase search |
| librarian | minimax-m2.5-free | External docs/refs |
| momus-code-reviewer | gpt-5.2 (xhigh) | Pre-commit audit |

## CUSTOM AGENT PATTERN

```markdown
---
name: <agent-name>
description: <purpose>
mode: subagent
model: <provider/model>
temperature: 0.1
tools:
  write: false  # Read-only agents
---

# Instructions
<system prompt>
```

## SKILL PATTERN

```markdown
---
name: <skill-name>
description: <when to invoke>
---

# <Workflow Title>
<steps to follow>
```

## CONVENTIONS

- Skills inject into parent agents via `@agent-name` calls
- Code review skill requires PASS from momus-code-reviewer before commit
- Read-only agents disable write/edit/bash tools in frontmatter
