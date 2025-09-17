# apply-config-patch
Apply custom config_patch changes after system update - READ EVERYTHING FIRST!

## ⚠️ CRITICAL: READ BEFORE DOING ANYTHING

### Step 0: UNDERSTAND THE STRUCTURE
1. config_patch contains YOUR CUSTOMIZATIONS that must survive system updates
2. System configs get updated and improved - DON'T overwrite them
3. Your job: MERGE customizations INTO updated system configs
4. NEVER replace system configs with config_patch directly
5. NEVER replace config_patch with system configs

### Step 1: READ ALL INSTRUCTIONS IN CONFIG_PATCH
```bash
# These files contain instructions - READ THEM:
cat /home/arc/.config/config_patch/CLAUDE.md
cat /home/arc/.config/config_patch/README.md 2>/dev/null

# Check for instruction comments in EACH file:
grep -h "^#" /home/arc/.config/config_patch/hypr/*.conf | head -20
grep -h "//" /home/arc/.config/config_patch/waybar/*.jsonc | head -20
```

### Step 2: ANALYZE WHAT'S CUSTOM
```bash
# List all config_patch files
find /home/arc/.config/config_patch -type f | grep -v ".git" | sort

# For EACH file, check if it has special instructions about WHERE it goes
# Example: windows.conf might say it goes somewhere OTHER than ~/.config/hypr/
```

## 📂 DESKTOP ENTRIES & ICONS

### Desktop Entries
```bash
# Safe to copy all - won't break anything
cp /home/arc/.config/config_patch/applications/*.desktop /home/arc/.local/share/applications/

# Icons too
mkdir -p /home/arc/.local/share/applications/icons/
cp /home/arc/.config/config_patch/applications/icons/* /home/arc/.local/share/applications/icons/
```

## ⌨️ HYPRLAND CONFIGS - COMPLEX MERGING REQUIRED

### Bindings.conf
```bash
# DON'T just copy! System might have improved commands
# 1. Compare files to understand differences
diff -u /home/arc/.config/config_patch/hypr/bindings.conf /home/arc/.config/hypr/bindings.conf

# 2. Identify:
#    - What's custom (your webapps, special keys)
#    - What's improved in system (new command syntax)
#
# 3. DECISION TREE:
#    - Is system using better commands? -> Update config_patch to match
#    - Are your custom bindings missing? -> Add them to system
#    - DON'T remove system improvements
```

### Windows.conf - CHECK WHERE IT BELONGS!
```bash
# READ the file first - it might contain instructions!
head -5 /home/arc/.config/config_patch/hypr/windows.conf

# If it says rules go elsewhere (like omarchy configs), put them there!
# If windows.conf shouldn't exist in ~/.config/hypr/, remove it
```

### Other Hypr Configs
```bash
# For each config file:
# 1. Check if it adds to or replaces system config
# 2. If it adds (like autostart), append missing lines
# 3. If it configures (like input), merge settings carefully
```

## 📊 WAYBAR - MOST ERROR-PRONE!

### UNDERSTAND THE CUSTOMIZATIONS FIRST
```bash
# Look for DELETED/REMOVED comments - these indicate intentional removals
grep -i "delete\|remove" /home/arc/.config/config_patch/waybar/*

# Understand what modules are custom
grep "modules-" /home/arc/.config/config_patch/waybar/config.jsonc
```

### Merging Waybar Config
1. DON'T replace the whole file
2. Identify custom modules (might be in modules-center, modules-right, etc.)
3. Add module definitions to system config
4. REMOVE modules if config_patch says they were deleted
5. Update existing modules if config_patch has different settings

### Waybar Styles
```bash
# Check if custom styles already exist before appending
# Avoid duplicating styles
```

### Waybar Scripts
```bash
# Check if scripts are referenced in config
# Copy only if they're actually used
```

## 🔍 VERIFICATION CHECKLIST

After applying, verify WITHOUT hardcoding expectations:

```bash
# Check desktop entries were copied
ls /home/arc/.local/share/applications/*.desktop | wc -l

# Check if custom modules exist in waybar (read from config_patch what to expect)
for module in $(grep -o '"custom/[^"]*"' /home/arc/.config/config_patch/waybar/config.jsonc); do
  grep -q "$module" /home/arc/.config/waybar/config.jsonc && echo "✓ $module" || echo "✗ $module missing"
done

# Check window rules are in correct location (wherever they should be)
# Check custom keybindings are present
# Check removed items are actually gone
```

## 🚫 COMMON FAILURES TO AVOID

1. **Assuming file locations**: Always check WHERE files should go
2. **Overwriting blindly**: Always MERGE, don't replace
3. **Ignoring comments**: Comments often contain critical instructions
4. **Not updating config_patch**: If system has improvements, backport them
5. **Adding duplicates**: Check before appending to avoid duplicates
6. **Missing removals**: If something was intentionally deleted, ensure it's removed

## 🔄 RECOVERY

If you mess up:
1. Config_patch is your source of truth for customizations
2. System configs can be restored from backups
3. NEVER modify config_patch unless updating it with system improvements

## 🎯 SUCCESS CRITERIA

You've succeeded when:
1. All custom apps/bindings work
2. No duplicate configurations
3. System improvements are preserved
4. Config_patch is updated with any system improvements
5. Intentionally removed items stay removed