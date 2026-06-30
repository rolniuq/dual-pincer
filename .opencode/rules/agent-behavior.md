---
description: Rules for how agents should behave when working on this project
mode: primary
---

# Agent Behavior Rules

## When Working on This Repo

1. **Context First** — Always read `context.md` and `agents.md` before making changes to understand the architecture
2. **Respect the Plugin Contract** — The `dp_analyze` tool is the heart of this plugin. Changes to it must maintain backward compatibility
3. **Document Changes** — Any new agent, command, or tool must be documented in `agents.md` and `README.md`
4. **No Breaking Changes** — The plugin's public API (the `dp_analyze` tool signature, agent names, command interface) should remain stable
5. **Keep It Simple** — This plugin does one thing (structured debate) and does it well. Avoid feature creep
