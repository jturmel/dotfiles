-- Personal monitor profiles migrated from monitors_custom.conf for Omarchy Quattro.
-- This file is loaded after Omarchy's packaged defaults.

hl.env("GDK_SCALE", "2")

-- Fallback for displays without a named profile.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.6 })

-- Home office: two LG 27GN950 displays.
hl.monitor({ output = "desc:LG Electronics 27GN950 203NTZNC4909", mode = "3840x2160@144", position = "0x0", scale = 1.6667 })
hl.monitor({ output = "desc:LG Electronics 27GN950 102NTGYB2991", mode = "3840x2160@144", position = "2304x0", scale = 1.6667 })

-- Work office: Lenovo P40WD-40.
hl.monitor({ output = "desc:Lenovo Group Limited P40WD-40 VKWD6889", mode = "5120x2160@120", position = "1440x0", scale = 1.333 })

-- Framework laptop when used without an external display.
hl.monitor({ output = "eDP-1", mode = "2880x1920@120", position = "0x0", scale = 2 })
