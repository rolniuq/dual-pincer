# Installation

## ⚡ One Click

Tell OpenCode:

> Fetch and follow instructions from https://raw.githubusercontent.com/rolniuq/dual-pincer/main/.opencode/INSTALL.md

---

## 🌍 Global Install (Manual)

If you prefer to do it yourself:

```bash
git clone git@github.com:rolniuq/dual-pincer.git
cd dual-pincer
bash bin/global-setup.sh
```

Or manually symlink everything:

```bash
mkdir -p ~/.config/opencode/agents ~/.config/opencode/commands
ln -sf $(pwd)/.opencode/agents/* ~/.config/opencode/agents/
ln -sf $(pwd)/.opencode/commands/* ~/.config/opencode/commands/
```

And ensure your `~/.config/opencode/opencode.jsonc` has:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["/absolute/path/to/dual-pincer/.opencode/plugins/dual-pincer-plugin.ts"]
}
```

---

## 📦 Project-Level Install (Per-Project Only)

### Using npm

```bash
npm install dual-pincer-plugin
```

Then add to your project's `.opencode/opencode.jsonc`:

```json
{
  "plugin": ["node_modules/dual-pincer-plugin/.opencode/plugins/dual-pincer-plugin.ts"]
}
```

### Using GitHub directly

```bash
npm install github:rolniuq/dual-pincer
```

Then add the same plugin reference.

### Local checkout

```bash
git clone git@github.com:rolniuq/dual-pincer.git
cd dual-pincer
npm install
```

Then reference it:

```json
{
  "plugin": ["../path/to/dual-pincer/.opencode/plugins/dual-pincer-plugin.ts"]
}
```

---

## 🔧 Install for Plugin Development

```bash
git clone git@github.com:rolniuq/dual-pincer.git
cd dual-pincer
npm install
```

All dependencies are in `.opencode/package.json`.
