# Dual Pincer Plugin — Context

## What Is This?

Dual Pincer is an [OpenCode](https://opencode.ai) plugin that implements a **structured debate protocol** for AI reasoning. Instead of getting a single answer from one agent, you get a mediated synthesis of two opposing analyses.

## Core Insight

The best reasoning comes from **structured disagreement**, not consensus. By forcing one agent to defend a position (Steelman) and another to attack it (Red Team), hidden assumptions surface that neither agent would find alone. The mediator then identifies the **crux** — the single point where the two analyses collide — and revises the output to address it.

## Architecture

```
User Prompt
    │
    ▼
┌──────────────────────────────────────┐
│        Mediator Agent                │
│  1. Drafts initial plan/response     │
│  2. Calls dp_analyze tool            │
│  3. Finds crux in opposing analyses  │
│  4. Produces revised output          │
└──────────┬───────────────────────────┘
           │
    ┌──────┴──────┐
    ▼             ▼
┌─────────┐  ┌─────────┐
│Steelman │  │Red Team │
│(defend) │  │(attack) │
└─────────┘  └─────────┘
```

## Key Concepts

- **Crux**: The single assumption or claim where Steelman says "fine" and Red Team says "broken." Finding this is the whole point of the exercise.
- **Steelman**: Builds the strongest possible defense of the draft. Anticipates and counters objections preemptively.
- **Red Team**: Attacks the draft ruthlessly. Finds hidden assumptions, edge cases, logical flaws, and failure modes.
- **Mediator**: Orchestrates the workflow. Does NOT evaluate the draft itself — that's the pincers' job.

## When to Use

- Complex decisions with tradeoffs (architecture, design, strategy)
- Plans where hidden risks could derail execution
- Prompts where you want to stress-test assumptions before committing
- Any scenario where a single AI opinion feels insufficient

## Project Structure

```
dual-pincer/
├── .opencode/
│   ├── agents/
│   │   ├── dual-pincer-mediator.md    ← Workflow orchestrator
│   │   ├── dual-pincer-steelman.md    ← Defense agent
│   │   └── dual-pincer-redteam.md     ← Attack agent
│   ├── commands/
│   │   └── dual-pincer.md             ← CLI entry point
│   ├── plugins/
│   │   └── dual-pincer-plugin.ts      ← Plugin code (dp_analyze tool)
│   ├── rules/                         ← OpenCode rules
│   └── opencode.jsonc                 ← Plugin registration
├── package.json                       ← npm package
├── README.md                          ← This file
├── context.md                         ← You are here
├── agents.md                          ← Agent documentation
└── LICENSE                            ← MIT
```
