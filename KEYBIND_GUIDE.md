# Beep Framework v3.2.2 - Keybind Security Guide

## 🔒 HOW KEYBINDS WORK NOW

All toggle keybinds have been secured to prevent accidental activation.

### ⚡ Quick Summary
**You MUST enable features in the menu FIRST before keybinds will work.**

Keybinds now only function as **quick disable buttons** - they can't turn features ON anymore.

---

## 📋 KEYBIND LIST

| Keybind | Feature | How It Works |
|---------|---------|--------------|
| **F1** | ESP Toggle | Only turns ESP OFF if it's ON in menu |
| **F2** | NoClip Toggle | Only turns NoClip OFF if it's ON in menu |
| **LeftControl** | Speed Toggle | Only turns Speed OFF if it's ON in menu |
| **E** | Fly Toggle | Only turns Fly OFF if it's ON in menu |
| **INSERT** | Menu Toggle | Opens/closes the menu (always works) |
| **Q** | Target Lock | Locks/unlocks aim target (always works) |

---

## 🎯 STEP-BY-STEP EXAMPLES

### Example 1: Using ESP
```
1. Press INSERT to open menu
2. Go to "Visual" tab
3. Click "Enable ESP" toggle to turn it ON
4. Close menu (press INSERT)
5. Now press F1 to turn ESP OFF quickly
6. To turn ESP back ON, open menu and enable it again
```

### Example 2: Using Fly Mode
```
1. Press INSERT to open menu
2. Go to "Physics" tab
3. Click "Fly Mode" toggle to turn it ON
4. Close menu (press INSERT)
5. Now press E to turn Fly OFF quickly
6. To turn Fly back ON, open menu and enable it again
```

### Example 3: Using Speed Hack
```
1. Press INSERT to open menu
2. Go to "Physics" tab
3. Click "Enable Speed Hack" toggle to turn it ON
4. Close menu (press INSERT)
5. Now press LeftControl to turn Speed OFF quickly
6. To turn Speed back ON, open menu and enable it again
```

### Example 4: Using NoClip
```
1. Press INSERT to open menu
2. Go to "Physics" tab
3. Click "NoClip" toggle to turn it ON
4. Close menu (press INSERT)
5. Now press F2 to turn NoClip OFF quickly
6. To turn NoClip back ON, open menu and enable it again
```

---

## ❌ WHAT WON'T WORK ANYMORE

### Scenario 1: Trying to activate ESP with F1
```
❌ BEFORE (v3.2.1 and earlier):
   - Press F1 → ESP turns ON (even without using menu)

✅ NOW (v3.2.2):
   - Press F1 → Nothing happens (ESP not enabled in menu)
   - Must open menu and enable ESP first
```

### Scenario 2: Trying to activate Fly with E
```
❌ BEFORE:
   - Press E → Fly turns ON (even without using menu)

✅ NOW:
   - Press E → Nothing happens (Fly not enabled in menu)
   - Must open menu and enable Fly first
```

---

## 🤔 WHY THIS CHANGE?

### Security & Control
- Prevents accidental activation from random key presses
- Forces intentional use through menu interaction
- Better control over when features activate
- More secure behavior overall

### User Experience
- Clear workflow: Menu → Enable → Use Keybind to Disable
- Prevents confusion from unexpected activations
- Consistent behavior across all features
- Quick disable when you need to turn off fast

---

## 💡 PRO TIPS

1. **Quick Disable in Emergencies**
   - Enable features you use often in the menu
   - Use keybinds to quickly turn them OFF when needed
   - Example: Admin nearby? Press F1 to instantly disable ESP

2. **Custom Keybinds**
   - You can change keybinds in the Misc tab
   - ESP Toggle Key (default: F1)
   - NoClip Toggle Key (default: F2)
   - Speed and Fly keys can be changed in Physics tab

3. **Always Works Keys**
   - INSERT (menu toggle) - Always works
   - Q (target lock) - Always works
   - These don't require menu interaction

---

## 🆘 TROUBLESHOOTING

### "My keybind isn't working!"
**Solution**: Open menu and enable the feature first. Keybinds only turn features OFF now.

### "I want to toggle ON and OFF with keybinds"
**Solution**: That's no longer possible for security reasons. Use menu to turn ON, keybind to turn OFF.

### "Can I change this behavior back?"
**Solution**: This is a security feature and cannot be disabled. It prevents accidental activations.

---

## 📊 FEATURE COMPARISON

| Version | Keybind Behavior | Security |
|---------|------------------|----------|
| **v3.2.1 and earlier** | Toggle ON/OFF anytime | ❌ Low (accidental activation) |
| **v3.2.2 (current)** | Only toggle OFF if enabled | ✅ High (menu-first approach) |

---

## 🎉 SUMMARY

**Keybinds are now quick disable buttons, not toggle switches.**

1. Enable features in menu first
2. Use keybinds to quickly turn them OFF
3. Go back to menu to turn them ON again

This provides better security and control while still allowing fast deactivation when needed.

**Current Version**: v3.2.2 - Security Edition  
**Last Updated**: June 21, 2026
