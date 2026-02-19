---@type LazySpec
return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
  },
  {
    "AstroNvim/astroui",
    opts = {
      colorscheme = "gruvbox",
      highlights = {
        init = {},
        astrodark = {},
      },
      icons = {
        LSPLoading1 = "⠋",
        LSPLoading2 = "⠙",
        LSPLoading3 = "⠹",
        LSPLoading4 = "⠸",
        LSPLoading5 = "⠼",
        LSPLoading6 = "⠴",
        LSPLoading7 = "⠦",
        LSPLoading8 = "⠧",
        LSPLoading9 = "⠇",
        LSPLoading10 = "⠏",
      },
    },
  },
}
