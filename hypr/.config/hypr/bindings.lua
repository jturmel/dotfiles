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

-- SUPER+W was Close window. For Messages, Basecamp, and FreshBooks:
-- keydown starts a 1s hold timer and a 1s hide alarm, window stays focused.
-- Alarm at 1s: if still showing, hide it and cancel the hold timer.
-- Keyup before 1s: hide. Keyup after the alarm hid it: close.
-- Use native hl APIs here; a synchronous shell round-trip deadlocks the compositor.
local hidden_workspace = "special:hidden"
local persistent_apps = {
  { fragments = { "messages.google.com" }, profile = "Default" },
  { fragments = { "launchpad.37signals.com", "3.basecamp.com" }, profile = "Work" },
  { fragments = { "my.freshbooks.com" }, profile = "Work" },
}
local pending_webapp = nil

local function ends_with(value, suffix)
  return suffix ~= "" and value:sub(-#suffix) == suffix
end

local function is_persistent_webapp(win)
  if not win then
    return false
  end

  local class = string.lower(win.class or "")
  local initial = string.lower(win.initial_class or "")

  for _, app in ipairs(persistent_apps) do
    local suffix = "-" .. string.lower((app.profile or ""):gsub(" ", "_"))
    for _, fragment in ipairs(app.fragments) do
      fragment = string.lower(fragment)
      for _, candidate in ipairs({ class, initial }) do
        if candidate:find(fragment, 1, true) and ends_with(candidate, suffix) then
          return true
        end
      end
    end
  end

  return false
end

local function cancel_timer(timer)
  if timer then
    timer:set_enabled(false)
  end
end

local function window_is_showing(win)
  return win ~= nil and win.workspace ~= nil and win.workspace.name ~= hidden_workspace
end

local function geometry_file(win)
  local dir = os.getenv("PERSISTENT_WEBAPP_GEOM_DIR") or os.getenv("XDG_RUNTIME_DIR") or "/tmp"
  return dir .. "/persistent-webapp-geom-" .. (win.class or "unknown") .. ".json"
end

local function save_window_geometry(win)
  if not win or not win.floating then
    return
  end

  local at = win.at or {}
  local size = win.size or {}
  local workspace = win.workspace
  local x = tonumber(at.x or at[1])
  local y = tonumber(at.y or at[2])
  local width = tonumber(size.x or size[1])
  local height = tonumber(size.y or size[2])
  local workspace_id = workspace and tonumber(workspace.id)
  if not (x and y and width and height) then
    return
  end

  local file = io.open(geometry_file(win), "w")
  if not file then
    return
  end

  if workspace_id and workspace_id > 0 then
    file:write(string.format(
      '{"x":%d,"y":%d,"w":%d,"h":%d,"workspace":%d}\n',
      x, y, width, height, workspace_id
    ))
  else
    file:write(string.format('{"x":%d,"y":%d,"w":%d,"h":%d}\n', x, y, width, height))
  end
  file:close()
end

local function hide_persistent_window(win)
  save_window_geometry(win)
  hl.animation({ leaf = "specialWorkspace", enabled = false })
  hl.dispatch(hl.dsp.window.set_prop({ prop = "no_anim", value = "1", window = win }))
  hl.dispatch(hl.dsp.window.move({
    workspace = hidden_workspace,
    follow = false,
    window = win,
  }))
  hl.animation({
    leaf = "specialWorkspace",
    enabled = true,
    speed = 3,
    bezier = "easeOutQuint",
    style = "slidevert",
  })
end

hl.unbind("SUPER + W")
o.bind("SUPER + W", "Hide persistent webapp or close window", function()
  -- A quick tap often releases Super before W. If that skips the release
  -- bind, pending_webapp leaks and the 1s hide alarm is what the user feels.
  if pending_webapp then
    if hl.is_key_down("W") then
      return
    end
    cancel_timer(pending_webapp.hold_timer)
    cancel_timer(pending_webapp.hide_alarm)
    pending_webapp = nil
  end

  local win = hl.get_active_window()
  if not is_persistent_webapp(win) then
    hl.dispatch(hl.dsp.window.close())
    return
  end

  pending_webapp = {
    address = win.address,
    held_long = false,
    auto_hidden = false,
  }
  pending_webapp.hold_timer = hl.timer(function()
    if pending_webapp then
      pending_webapp.held_long = true
    end
  end, { timeout = 1000, type = "oneshot" })
  pending_webapp.hide_alarm = hl.timer(function()
    local pending = pending_webapp
    if not pending then
      return
    end

    cancel_timer(pending.hold_timer)
    pending.hold_timer = nil
    pending.held_long = true
    pending.auto_hidden = true

    local target = hl.get_window("address:" .. pending.address)
    if window_is_showing(target) then
      hide_persistent_window(target)
    end

    -- Keyup never arrived; don't leave pending around to close on a later W.
    if not hl.is_key_down("W") then
      pending_webapp = nil
    end
  end, { timeout = 1000, type = "oneshot" })
end)
hl.bind("SUPER + W", function()
  local pending = pending_webapp
  pending_webapp = nil
  if not pending then
    return
  end

  cancel_timer(pending.hold_timer)
  cancel_timer(pending.hide_alarm)

  local target = hl.get_window("address:" .. pending.address)
  if not target then
    return
  end

  if pending.held_long or pending.auto_hidden then
    hl.dispatch(hl.dsp.window.close({ window = target }))
    return
  end

  hide_persistent_window(target)
  -- ignore_mods: Super is often already up on a fast tap; still handle W release.
  -- non_consuming: don't eat normal W keyups when no gesture is pending.
end, { release = true, ignore_mods = true, non_consuming = true })
