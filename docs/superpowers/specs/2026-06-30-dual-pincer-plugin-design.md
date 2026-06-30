# Dual Pincer Plugin — Design Spec

## Concept

Two independent, concurrent agents analyze the same draft plan from opposite directions:
- **Pincer A (Steelman):** Proves the draft RIGHT — builds the strongest defense
- **Pincer B (Red team):** Proves the draft WRONG — tries to break it

They are blind to each other (separate contexts). A mediator reads only the **crux** — the one assumption where they fundamentally disagree — and produces a revised plan.

## Flow

```
User prompt
    │
    ▼
1. MAIN AGENT produces draft plan/answer
    │
    ▼
2. TWO PINCERS (parallel, forked sessions, concurrent)
   ┌─────────────────┐   ┌─────────────────┐
   │ Pincer A        │   │ Pincer B        │
   │ "Steelman"      │   │ "Red team"      │
   │ Proves it right │   │ Proves it wrong │
   └────────┬────────┘   └────────┬────────┘
            │                     │
            ▼                     ▼
   "Strongest defense"    "Strongest attack"
            │                     │
            └─────────┬───────────┘
                      ▼
3. MEDIATOR finds the CRUX — where A says "fine" and B says "broken"
                      │
                      ▼
4. REVISED ANSWER — better plan that survives the beating
```

## Components

### Plugin — `dual-pincer-plugin.ts`
Registers 4 tools and manages forked sessions.

**Tools:**

| Tool | Args | Behavior |
|------|------|----------|
| `dp_draft` | `plan: string` | Accepts a draft plan for analysis. Creates two forked sessions (A and B) concurrently via `promptAsync`, returns session IDs |
| `dp_pincer_a` | `draft: string`, `session_id: string` | Blocks until Pincer A fork completes, returns steelman analysis |
| `dp_pincer_b` | `draft: string`, `session_id: string` | Blocks until Pincer B fork completes, returns red-team analysis |
| `dp_crux` | `defense: string`, `attack: string` | Mediator identifies crux and produces revised plan |

### Command — `dual-pincer.md`
`/dual-pincer <prompt>` — triggers the mediator agent with the user's prompt.

### Agent prompts

Three agents:

- **dual-pincer-mediator.md** — primary agent that orchestrates the flow:
  1. Produces the draft plan
  2. Calls `dp_draft` to submit it to both pincers
  3. Reads both analyses
  4. Calls `dp_crux` to find the crux and produce a revision

- **dual-pincer-steelman.md** — subagent run in forked session A. Gets only the draft + user prompt. Task: build the strongest case.

- **dual-pincer-redteam.md** — subagent run in forked session B. Gets only the draft + user prompt. Task: try to break it.

## Independence Requirement

Pincer B must NOT see Pincer A's output. This is achieved by:
- Forking the session at the point before either pincer runs
- Each fork gets ONLY the draft + its role-specific system prompt
- The mediator receives both results independently

## Concurrency

Both pincer sessions are created via `client.session.fork()` and kicked off via `client.session.promptAsync()`. The mediator polls for both completions, then reconciles.
