# Installing Dual Pincer Plugin

This file contains everything you need to install the dual-pincer plugin globally.

## What this does

1. Symlinks agents to `~/.config/opencode/agents/` so they're available in any project
2. Symlinks the `/dual-pincer` command to `~/.config/opencode/commands/`
3. Registers the plugin in `~/.config/opencode/opencode.jsonc`

## Prerequisites

- [OpenCode.ai](https://opencode.ai) installed
- This repo cloned to your machine

## Installation Steps

### 1. Find the repo path

The repo is at the current directory. Get its absolute path.

### 2. Symlink the agents

Create `~/.config/opencode/agents/` if it doesn't exist, then symlink:

- `{repo}/.opencode/agents/dual-pincer-mediator.md`
- `{repo}/.opencode/agents/dual-pincer-steelman.md`
- `{repo}/.opencode/agents/dual-pincer-redteam.md`

into `~/.config/opencode/agents/`.

### 3. Symlink the command

Create `~/.config/opencode/commands/` if it doesn't exist, then symlink:

- `{repo}/.opencode/commands/dual-pincer.md`

into `~/.config/opencode/commands/`.

### 4. Register the plugin

Ensure `~/.config/opencode/opencode.jsonc` contains:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["{repo}/.opencode/plugins/dual-pincer-plugin.ts"]
}
```

If the file already exists with other plugins, add this to the `plugin` array.

### 5. Verify

After installation, opening OpenCode in any project should let you run:

```
/dual-pincer <your prompt>
```

## Troubleshooting

- If `/dual-pincer` doesn't appear, check that the symlinks exist in `~/.config/opencode/agents/` and `~/.config/opencode/commands/`
- If `dp_analyze` tool isn't available, check that the plugin path in `opencode.jsonc` is correct
