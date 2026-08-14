-- Active window rules migrated from windows.conf for Omarchy Quattro.

-- Screaming Frog windows and its dialog windows.
o.window("uk.co.screamingfrog.*", { tag = "+sfs" })
o.window({ class = "dialog_class", tag = "sfs" }, { float = true, no_focus = true })

-- 1Password.
o.window("1password", {
  float = true,
  center = true,
  opacity = "1.0 override 1.0 override",
  size = { "monitor_w * 0.85", "monitor_h * 0.85" },
  dim_around = true,
})

-- Discord.
o.window("com.discordapp.Discord", {
  float = true,
  center = true,
  opacity = "1.0 override 1.0 override",
  size = { "min((monitor_w * 0.85), 1600)", "monitor_h * 0.85" },
  dim_around = true,
})

-- Basecamp, FreshBooks, and Slack.
o.window("(chrome-3.basecamp.com.*|chrome-launchpad.37signals.com.*|Slack|chrome-my.freshbooks.com.*)", { tag = "+modal_large" })
o.window({ tag = "modal_large" }, {
  float = true,
  center = true,
  opacity = "1.0 override 1.0 override",
  size = { 1200, "monitor_h * 0.85" },
  dim_around = true,
})

-- Google Messages.
o.window("chrome-messages.google.com.*", { tag = "+google-messages" })
o.window({ tag = "google-messages" }, {
  float = true,
  center = true,
  opacity = "1.0 override 1.0 override",
  size = { 480, "monitor_h * 0.85" },
  dim_around = true,
})

-- Google Meet picture-in-picture.
o.window({ title = "^Meet.*" }, {
  float = true,
  size = { 640, 480 },
  move = { 0, 600 },
  opacity = "1.0 override 1.0 override",
  no_initial_focus = true,
  no_shadow = true,
  opaque = true,
  force_rgbx = true,
  decorate = false,
  pin = true,
})
