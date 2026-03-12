return {
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = false,
        },
        neorg = {
          enabled = false,
        },
        typst = {
          enabled = false,
        },
      },
      max_width = 100,
      max_height = 40,
      max_width_window_percentage = math.huge,
      max_height_window_percentage = math.huge,
      scale_factor = 1.0,
      hijack_file_patterns = {
        "*.png",
        "*.jpg",
        "*.jpeg",
        "*.gif",
        "*.webp",
        "*.avif",
        "*.bmp",
      },
    },
  },
}
