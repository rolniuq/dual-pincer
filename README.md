# Dual Pincer Plugin

> **An OpenCode plugin that runs two independent AI agents in parallel to debate any plan or prompt from opposite directions, then reconciles their analyses into a stronger result.**

[![GitHub](https://img.shields.io/badge/github-rolniuq/dual--pincer-blue)](https://github.com/rolniuq/dual-pincer)
[![npm](https://img.shields.io/npm/v/dual-pincer-plugin)](https://www.npmjs.com/package/dual-pincer-plugin)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## How It Works

Dual Pincer applies a structured debate workflow to any prompt:

```
User Prompt  ──▶  Mediator Drafts Plan
                       │
              ┌────────┴────────┐
              ▼                 ▼
         Steelman           Red Team
       (defends it)       (attacks it)
              │                 │
              └────────┬────────┘
                       ▼
              Mediator finds the CRUX
                       │
                       ▼
              Revised, stronger result
```

1. **Draft** — The mediator agent analyzes your request and produces a draft plan/response
2. **Debate** — Two independent agents review the draft simultaneously:
   - **Steelman (Pincer A)** — Argues why the draft is RIGHT (strongest defense)
   - **Red Team (Pincer B)** — Argues why the draft is WRONG (strongest attack)
3. **Crux** — The mediator finds the single key point of disagreement between the two analyses
4. **Revise** — The mediator produces a final response that addresses the crux

The result is a better answer than either agent alone could produce.

---

## Installation

Open OpenCode, then copy this prompt and paste into terminal:

```
Run bash bin/global-setup.sh to install dual-pincer plugin globally by symlinking agents/commands into ~/.config/opencode/ and registering it in opencode.jsonc
```

That's it. OpenCode will handle everything.

---

## Usage

### Via CLI command

```
/dual-pincer <your prompt>
```

### Via mediator agent directly

Run the `dual-pincer-mediator` agent from OpenCode's agent picker.

### Via `dp_analyze` tool

Any agent that has the `dp_analyze` tool enabled can call it:

```
Use dp_analyze with this draft: ...
```

### Example

```
/dual-pincer Should we migrate from REST to GraphQL?
```

The mediator will:
1. Draft a migration plan
2. Have Steelman argue FOR and Red Team argue AGAINST
3. Find the crux of the disagreement
4. Give you a revised, stronger recommendation

---

## What's the Crux?

The **crux** is the single assumption or claim where Steelman says "looks fine" and Red Team says "this is broken." Most debate happens at the edges — the crux is where they collide head-on. By identifying it, you get a targeted insight that no single agent would surface on its own.

---

## Agents & Commands

This plugin registers three agents and one command:

| Name | Mode | Description |
|------|------|-------------|
| `dual-pincer-mediator` | `primary` | Orchestrates the full workflow (draft → analyze → crux → revise) |
| `dual-pincer-steelman` | `subagent` | Pincer A — builds the strongest defense of the draft |
| `dual-pincer-redteam` | `subagent` | Pincer B — attacks the draft ruthlessly |
| `/dual-pincer` | command | CLI shortcut to invoke the mediator |

See [`agents.md`](agents.md) for detailed documentation.

---

## File Structure

```
dual-pincer/
├── .opencode/
│   ├── agents/
│   │   ├── dual-pincer-mediator.md      ← Workflow orchestrator
│   │   ├── dual-pincer-steelman.md      ← Defense agent
│   │   └── dual-pincer-redteam.md       ← Attack agent
│   ├── commands/
│   │   └── dual-pincer.md               ← CLI entry point
│   ├── plugins/
│   │   └── dual-pincer-plugin.ts        ← Plugin code (dp_analyze tool)
│   ├── rules/
│   │   ├── development.md               ← Development rules
│   │   └── agent-behavior.md            ← Agent behavior rules
│   └── opencode.jsonc                   ← Plugin registration
├── bin/
│   └── global-setup.sh                  ← One-command global install script
├── package.json                         ← npm package manifest
├── README.md                            ← You are here
├── INSTALL.md                           ← Installation instructions
├── context.md                           ← Project context for AI agents
├── agents.md                            ← Agent documentation
└── LICENSE                              ← MIT
```

---

## License

MIT — see [LICENSE](LICENSE).

---

## Links

- **GitHub:** [rolniuq/dual-pincer](https://github.com/rolniuq/dual-pincer)
- **npm:** [dual-pincer-plugin](https://www.npmjs.com/package/dual-pincer-plugin)
- **OpenCode:** [opencode.ai](https://opencode.ai)
