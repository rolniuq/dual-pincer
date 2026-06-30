# Installation

## 🎯 Install as an OpenCode Plugin

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
