COMMIT INSTRUCTIONS: use conventional commits guidelines, 1 GRANULAR COMMIT PER 1 GOAL, MESSAGE 50 CHARACTERS MAX, NO DESCRIPTION

### Desktop Entries, Icons & Shortcuts Management

**Desktop Entry Locations:**
- User desktop files: `/home/arc/.local/share/applications/`
- User icons: `/home/arc/.local/share/applications/icons/`
- System desktop files: `/usr/share/applications/`

**Hyprland Keybindings:**
- Main config: `/home/arc/.config/hypr/bindings.conf`
- Default bindings: `/home/arc/.local/share/omarchy/default/hypr/bindings/`
- Format: `bindd = SUPER, KEY, Description, exec, command`
- Web apps use: `omarchy-launch-webapp "https://example.com"`

### Config Patch Workflow
**CRITICAL: All changes to ~/.config must also be added to config_patch**

- Config patch location: `/home/arc/.config/config_patch/`
- Structure mirrors ~/.config/ directory
- When adding desktop entries:
  1. Copy `.desktop` file to `config_patch/applications/`
  2. Copy icon to `config_patch/applications/icons/`
  3. Add keybindings to `config_patch/hypr/bindings.conf`
  4. Commit with conventional commit format
- Always commit changes to config_patch using: `feat(category): description`
