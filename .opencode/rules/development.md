---
description: Development rules for the dual-pincer plugin
mode: primary
---

# Development Rules

## Plugin Development

- The plugin source is at `.opencode/plugins/dual-pincer-plugin.ts`
- It imports from `@opencode-ai/plugin` — do NOT add other external dependencies
- Agent definitions go in `.opencode/agents/` as markdown files with YAML frontmatter
- Command definitions go in `.opencode/commands/` as markdown files with YAML frontmatter

## Testing

- After any change to `.opencode/plugins/dual-pincer-plugin.ts`, verify the plugin loads without errors
- After any change to agent/command md files, verify the agent/command is discoverable
- Run `opencode plugin:verify` if available to check plugin integrity

## Publishing

- Update `version` in `package.json` before publishing
- Tag releases: `git tag v<version> && git push --tags`
- Publish to npm: `npm publish`
- The published package includes: `.opencode/plugins/`, `.opencode/agents/`, `.opencode/commands/`, `README.md`, `LICENSE`

## Commit Style

- Use conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`, `chore:`
- Keep commits small and focused on a single change
- Reference issues when applicable
