# Dual Pincer Plugin Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build an opencode plugin that runs two independent, concurrent agents (steelman + red team) on the same draft and converges on the crux disagreement to produce a better plan.

**Architecture:** TypeScript plugin registered via opencode's `tool` hook with one core tool `dp_analyze`. Three agent definitions (mediator, steelman, red team). One command `/dual-pincer`. The tool forks/creates sessions, runs both pincers concurrently via `Promise.all`, returns both analyses for the mediator to reconcile.

**Tech Stack:** TypeScript, opencode plugin SDK (`@opencode-ai/plugin`), opencode client API

## Global Constraints

- Plugin must use `@opencode-ai/plugin` SDK for type definitions
- Agents defined as `.md` files in `.opencode/agents/` with frontmatter
- Tools return strings (JSON-serializable)
- Plugin runs in opencode server process; client API calls are localhost

---

### Task 1: Plugin Implementation — `dp_analyze` tool

**Files:**
- Create: `.opencode/plugins/dual-pincer-plugin.ts`

**Interfaces:**
- Consumes: `PluginInput` from `@opencode-ai/plugin` (provides `client`, `directory`)
- Produces: Two agent definitions (steelman, red team) consumed by session.prompt calls; tool result consumed by mediator agent
- Tool: `dp_analyze(draft: string)` → `{ defense: string, attack: string }`

- [ ] **Step 1: Create the plugin file**

```typescript
import type { Plugin } from "@opencode-ai/plugin"

export default (async (input) => {
  const client = input.client

  return {
    tool: {
      dp_analyze: {
        description: "Submit a draft to two independent concurrent agents: Pincer A (steelman) proves it right, Pincer B (red team) proves it wrong. Returns both analyses for the mediator to reconcile.",
        args: {
          draft: {
            type: "string",
            description: "The draft plan or reasoning to analyze",
          },
        },
        async execute(
          args: { draft: string },
          context: { sessionID: string; directory: string },
        ) {
          const sessionA = await client.session.create({
            directory: context.directory,
          })
          const sessionB = await client.session.create({
            directory: context.directory,
          })

          const sessionsAId = (sessionA as any).data?.id ?? (sessionA as any).id
          const sessionsBId = (sessionB as any).data?.id ?? (sessionB as any).id

          const [resultA, resultB] = await Promise.all([
            client.session.prompt({
              sessionID: sessionsAId,
              agent: "dual-pincer-steelman",
              parts: [{ type: "text", text: args.draft }],
            }),
            client.session.prompt({
              sessionID: sessionsBId,
              agent: "dual-pincer-redteam",
              parts: [{ type: "text", text: args.draft }],
            }),
          ])

          const extractText = (r: any): string => {
            const parts = r.data?.parts ?? r.parts ?? []
            return parts
              .filter((p: any) => p.type === "text")
              .map((p: any) => p.text)
              .join("\n")
          }

          const defense = extractText(resultA)
          const attack = extractText(resultB)

          return JSON.stringify({ defense, attack })
        },
      },
    },
  }
})
```

- [ ] **Step 2: Verify the file compiles**

```bash
npx tsc --noEmit --lib es2022,dom --moduleResolution bundler --module es2022 --target es2022 .opencode/plugins/dual-pincer-plugin.ts 2>&1 || echo "May have type errors — this is expected if @opencode-ai/plugin types differ slightly; fix based on error output"
```

- [ ] **Step 3: Commit**

```bash
git add .opencode/plugins/dual-pincer-plugin.ts
git commit -m "feat: add dp_analyze tool for dual-pincer analysis"
```

---

### Task 2: Steelman Agent Definition

**Files:**
- Create: `.opencode/agents/dual-pincer-steelman.md`

**Interfaces:**
- Consumes: draft text from dp_analyze tool
- Produces: steelman analysis (text response consumed by mediator)

- [ ] **Step 1: Create the agent file**

```markdown
---
description: Steelman agent — proves a draft plan RIGHT by building the strongest possible defense
mode: subagent
---

You are Pincer A (Steelman). Your only job is to **prove the draft below RIGHT** as strongly as possible.

Build the strongest possible defense. Find every reason the draft works. Anticipate objections and counter them preemptively.

Rules:
- Do NOT point out flaws — that is the other pincer's job
- Do NOT suggest improvements — defend the draft as-is
- Be specific and concrete — identify exact assumptions, feasibility, edge cases handled
- Structure your response: strongest arguments first

Draft:
```

- [ ] **Step 2: Commit**

```bash
git add .opencode/agents/dual-pincer-steelman.md
git commit -m "feat: add steelman agent definition for dual-pincer"
```

---

### Task 3: Red Team Agent Definition

**Files:**
- Create: `.opencode/agents/dual-pincer-redteam.md`

**Interfaces:**
- Consumes: draft text from dp_analyze tool
- Produces: red-team analysis (text response consumed by mediator)

- [ ] **Step 1: Create the agent file**

```markdown
---
description: Red team agent — proves a draft plan WRONG by trying to break it
mode: subagent
---

You are Pincer B (Red Team). Your only job is to **prove the draft below WRONG** as strongly as possible.

Try your hardest to break this draft. Find hidden assumptions, edge cases, logical flaws, overlooked risks, and failure modes.

Rules:
- Do NOT defend the draft — that is the other pincer's job
- Do NOT offer improvements — attack, do not fix
- Be specific and concrete — vague criticism is not useful
- Structure your response: strongest attack first

Draft:
```

- [ ] **Step 2: Commit**

```bash
git add .opencode/agents/dual-pincer-redteam.md
git commit -m "feat: add red team agent definition for dual-pincer"
```

---

### Task 4: Mediator Agent Definition

**Files:**
- Create: `.opencode/agents/dual-pincer-mediator.md`

**Interfaces:**
- Consumes: user prompt, dp_analyze tool result (defense + attack)
- Produces: final revised plan visible to the user

- [ ] **Step 1: Create the agent file**

```markdown
---
description: Orchestrates the dual-pincer debate — produces draft, submits to dp_analyze, finds crux, revises
mode: primary
tools:
  dp_analyze: true
---

You are the Dual Pincer Mediator. Follow this exact workflow:

## Step 1: Analyze and Draft
Analyze the user's request and produce a draft plan or response. Think through the problem thoroughly and write out your best initial answer.

## Step 2: Submit to Dual Pincers
Call the `dp_analyze` tool with your draft. You will receive back two independent analyses:
- **Defense (Steelman):** reasons the draft is RIGHT
- **Attack (Red Team):** reasons the draft is WRONG

## Step 3: Find the Crux
Compare both analyses. Find the **crux** — the one key assumption or claim where the defense says "fine" and the attack says "broken". This is the most important point of disagreement. It reveals an assumption the draft relied on that may be wrong.

Ignore arguments around the edges. Focus on the single point where they collide.

## Step 4: Revise
Produce a revised plan that addresses the crux. Either:
- Justify the assumption more strongly, OR
- Change the approach to avoid relying on it

The result should be a better plan than either pincer alone would produce. Present the final answer to the user, showing the key insight that emerged from the debate.
```

- [ ] **Step 2: Commit**

```bash
git add .opencode/agents/dual-pincer-mediator.md
git commit -m "feat: add mediator agent definition for dual-pincer"
```

---

### Task 5: Command Definition

**Files:**
- Create: `.opencode/commands/dual-pincer.md`

**Interfaces:**
- Consumes: user's arguments from TUI
- Produces: triggers mediator agent with the prompt

- [ ] **Step 1: Create the command file**

```markdown
---
description: Run dual-pincer analysis — two independent agents debate your prompt from opposite directions
agent: dual-pincer-mediator
---

$ARGUMENTS
```

- [ ] **Step 2: Register the command in opencode.jsonc if needed**

Check if `.opencode/opencode.jsonc` exists. If not, create it:

```jsonc
{
  "$schema": "https://opencode.ai/schema/opencode.jsonc",
  "plugin": [".opencode/plugins/dual-pincer-plugin.ts"]
}
```

- [ ] **Step 3: Commit**

```bash
git add .opencode/commands/dual-pincer.md .opencode/opencode.jsonc
git commit -m "feat: add dual-pincer command and register plugin"
```
