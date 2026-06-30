# Dual Pincer Agents

This plugin registers **three agents** and **one command**.

---

## Mediator Agent

**File:** `.opencode/agents/dual-pincer-mediator.md`
**Mode:** `primary`
**Tools:** `dp_analyze`

The mediator is the orchestrator. It follows an exact 4-step workflow:

| Step | Action | Description |
|------|--------|-------------|
| 1 | **Analyze & Draft** | Analyzes the user's request and produces a draft plan or response |
| 2 | **Submit to Dual Pincers** | Calls `dp_analyze` tool with the draft, spawning Steelman and Red Team in parallel |
| 3 | **Find the Crux** | Compares both analyses to find the single key point of disagreement |
| 4 | **Revise** | Produces a final answer that addresses the crux |

The mediator does NOT evaluate the draft itself. That separation of concerns is by design — the mediator judges only the *debate*, not the *initial position*.

---

## Steelman Agent (Pincer A)

**File:** `.opencode/agents/dual-pincer-steelman.md`
**Mode:** `subagent`

The Steelman's only job is to **prove the draft RIGHT** as strongly as possible.

**Rules:**
- Build the strongest possible defense of the draft as-is
- Anticipate and counter objections preemptively
- Do NOT point out flaws (that's Red Team's job)
- Do NOT suggest improvements (defend, don't fix)
- Be specific and concrete — identify exact assumptions, feasibility, edge cases handled
- Structure response: strongest arguments first

**Best for:** Ensuring your plan gets a fair hearing before being torn down.

---

## Red Team Agent (Pincer B)

**File:** `.opencode/agents/dual-pincer-redteam.md`
**Mode:** `subagent`

The Red Team's only job is to **prove the draft WRONG** as strongly as possible.

**Rules:**
- Find hidden assumptions, edge cases, logical flaws, overlooked risks, and failure modes
- Do NOT defend the draft (that's Steelman's job)
- Do NOT offer improvements (attack, don't fix)
- Be specific and concrete — vague criticism is not useful
- Structure response: strongest attack first

**Best for:** Surfacing risks and blind spots before they become problems in production.

---

## CLI Command

**File:** `.opencode/commands/dual-pincer.md`
**Agent:** `dual-pincer-mediator`

The `/dual-pincer` command passes your prompt directly to the mediator agent:

```
/dual-pincer Should we migrate from REST to GraphQL?
```

This is equivalent to running the mediator with your prompt as input.

---

## How They Work Together

```
User: /dual-pincer <prompt>
  │
  ▼
Mediator ──draft──▶ dp_analyze tool
                      │
            ┌─────────┴─────────┐
            ▼                   ▼
        Steelman             Red Team
        (defends)            (attacks)
            │                   │
            └─────────┬─────────┘
                      ▼
              Mediator finds crux
                      │
                      ▼
              Revised, stronger result
```

The magic happens in the **crux** — the single assumption where Steelman says "looks fine" and Red Team says "this is broken." By zeroing in on that point, the mediator produces a revision that addresses the real tension, not just surface-level objections.
