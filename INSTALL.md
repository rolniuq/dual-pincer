# Installation

## 🌍 Global Install (Available in ALL projects)

The easiest way to use Dual Pincer everywhere — in any project, any terminal:

### Option 1: Using the setup script

```bash
git clone git@github.com:rolniuq/dual-pincer.git
cd dual-pincer
bash bin/global-setup.sh
```

This symlinks the agents/commands into `~/.config/opencode/` and registers the plugin globally.

### Option 2: Manual global setup

```bash
# 1. Register the plugin in your global OpenCode config
echo '{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["/absolute/path/to/dual-pincer/.opencode/plugins/dual-pincer-plugin.ts"]
}' > ~/.config/opencode/opencode.jsonc

# 2. Symlink agents so OpenCode can find them globally
mkdir -p ~/.config/opencode/agents ~/.config/opencode/commands
ln -sf /absolute/path/to/dual-pincer/.opencode/agents/* ~/.config/opencode/agents/
ln -sf /absolute/path/to/dual-pincer/.opencode/commands/* ~/.config/opencode/commands/
```

Now open OpenCode in **any** project and you can run `/dual-pincer <your prompt>`.

---

## 🎯 Project-Level Install (Per-Project Only)

### Option A: Using npm (recommended)

```bash
npm install dual-pincer-plugin
```

Then register the plugin in your project's `.opencode/opencode.jsonc`:

```json
{
  "plugin": ["node_modules/dual-pincer-plugin/.opencode/plugins/dual-pincer-plugin.ts"]
}
```

> **Note:** The plugin's agents (`dual-pincer-mediator`, `dual-pincer-steelman`, `dual-pincer-redteam`) and command (`/dual-pincer`) are auto-discovered from the package's `.opencode/` directory.

### Option B: Using GitHub directly

```bash
npm install github:rolniuq/dual-pincer
```

Then add the same plugin reference to your `.opencode/opencode.jsonc`.

### Option C: Local checkout

```bash
git clone git@github.com:rolniuq/dual-pincer.git
cd dual-pincer
npm install
```

Then reference it from your project's `.opencode/opencode.jsonc`:

```json
{
  "plugin": ["../path/to/dual-pincer/.opencode/plugins/dual-pincer-plugin.ts"]
}
```

Or if you're working inside the cloned repo itself, it's already configured:

```json
{
  "plugin": [".opencode/plugins/dual-pincer-plugin.ts"]
}
```

---

## 📦 Install for Plugin Development

```bash
git clone git@github.com:rolniuq/dual-pincer.git
cd dual-pincer
npm install
```

The plugin is self-contained. All dependencies are in `.opencode/package.json`.
