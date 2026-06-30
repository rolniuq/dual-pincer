# Dual Pincer Plugin

> **An OpenCode plugin that runs two independent AI agents in parallel to debate any plan or prompt from opposite directions, then reconciles their analyses into a stronger result.**

## How It Works

Dual Pincer applies a structured debate workflow to any prompt:

1. **Draft** — The mediator agent analyzes your request and produces a draft plan/response
2. **Debate** — Two independent agents review the draft simultaneously:
   - **Steelman (Pincer A)** — Argues why the draft is RIGHT (strongest defense)
   - **Red Team (Pincer B)** — Argues why the draft is WRONG (strongest attack)
3. **Crux** — The mediator finds the single key point of disagreement between the two analyses
4. **Revise** — The mediator produces a final response that addresses the crux

The result is a better answer than either agent alone could produce.

## Installation

### Prerequisites

- [OpenCode](https://opencode.ai) CLI with plugin support

### Install via npm

```bash
npm install dual-pincer-plugin
```

Then add it to your `.opencode/opencode.jsonc`:

```json
{
  "plugin": ["node_modules/dual-pincer-plugin/.opencode/plugins/dual-pincer-plugin.ts"]
}
```

### Or install directly from GitHub

```bash
npm install github:rolniuq/dual-pincer
```

### Local development install

Clone the repo and reference it directly:

```json
{
  "plugin": [".opencode/plugins/dual-pincer-plugin.ts"]
}
```

## Usage

Use the command or invoke the mediator agent directly:

```
/dual-pincer <your prompt>
```

Or use the `dp_analyze` tool from any agent that has it enabled.

### Example

```
/dual-pincer Should we use React Server Components for our new dashboard?
```

The mediator will:
1. Draft a plan for using RSC
2. Have Steelman argue FOR and Red Team argue AGAINST
3. Find the crux of the disagreement
4. Give you a revised, stronger recommendation

## Agent Files

This plugin registers three agents and one command:

| File | Purpose |
|------|---------|
| `dual-pincer-mediator` | Orchestrator — runs the full workflow |
| `dual-pincer-steelman` | Subagent — defends the draft |
| `dual-pincer-redteam` | Subagent — attacks the draft |
| `/dual-pincer` | CLI command — shortcut to invoke the mediator |

## License

MIT
