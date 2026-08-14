-- Personal keybindings migrated from keybindings.conf for Omarchy Quattro.
-- This file is loaded after Omarchy's packaged defaults.

local function replace(keys, description, dispatcher)
  hl.unbind(keys)
  o.bind(keys, description, dispatcher)
end

-- Quattro defaults replaced by personal bindings.
replace("SUPER + SHIFT + B", "Browser", [[omarchy-launch-or-focus-webapp '^chrome-personal.*$' "chrome://newtab --profile-directory='Default'"]])
replace("SUPER + SHIFT + C", "Basecamp", [[gio launch "$HOME/.local/share/applications/Basecamp.desktop"]])
replace("SUPER + SHIFT + D", "Discord", "gio launch /var/lib/flatpak/exports/share/applications/com.discordapp.Discord.desktop")
replace("SUPER + SHIFT + M", "Messages", [[gio launch "$HOME/.local/share/applications/Google Messages.desktop"]])
replace("SUPER + 7", "Workspace 4, then 1", "hyprctl dispatch workspace 4; hyprctl dispatch workspace 1")
replace("SUPER + 8", "Workspace 5, then 2", "hyprctl dispatch workspace 5; hyprctl dispatch workspace 2")
replace("SUPER + 9", "Workspace 6, then 3", "hyprctl dispatch workspace 6; hyprctl dispatch workspace 3")

-- Personal shortcuts that do not replace an Omarchy default.
o.bind("SHIFT + ALT + 4", "Screenshot to Clipboard", "omarchy-capture-screenshot smart copy")
o.bind("SHIFT + ALT + B", "Browser", [[omarchy-launch-or-focus-webapp '^chrome-work.*$' "chrome://newtab --profile-directory='Work'"]])
o.bind("SUPER + SHIFT + L", "Lock Screen", "omarchy-system-lock")
