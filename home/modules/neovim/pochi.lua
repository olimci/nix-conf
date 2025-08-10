vim.g.colors_name = "pochi"

local k = {
  bg   = "#0d0014",
  fg   = "#e7d8ef",
  sel  = "#281033",
  cur  = "#ff339c",

  dim1 = "#39213d",
  dim2 = "#1a0822",

  red     = "#a00080",
  green   = "#22e7ff",
  yellow  = "#ffbcd4",
  blue    = "#008ff6",
  magenta = "#ff7bf0",
  cyan    = "#8ffeff",
  violet  = "#9058ff",
  purple  = "#6000c0",
  pink    = "#ff339c",
}

local function hi(g, opts) vim.api.nvim_set_hl(0, g, opts) end

vim.g.terminal_color_0  = "#1a0822"
vim.g.terminal_color_1  = "#a00080"
vim.g.terminal_color_2  = "#008ff6"
vim.g.terminal_color_4  = "#6000c0"
vim.g.terminal_color_5  = "#c000a0"
vim.g.terminal_color_6  = "#009aad"
vim.g.terminal_color_7  = "#d5d1e8"
vim.g.terminal_color_8  = "#39213d"
vim.g.terminal_color_9  = "#ff339c"
vim.g.terminal_color_10 = "#22e7ff"
vim.g.terminal_color_11 = "#ffbcd4"
vim.g.terminal_color_12 = "#9058ff"
vim.g.terminal_color_13 = "#ff7bf0"
vim.g.terminal_color_14 = "#8ffeff"
vim.g.terminal_color_15 = "#ffffff"

hi("Normal",       { fg = k.fg, bg = k.bg })
hi("NormalNC",     { fg = k.fg, bg = k.bg })
hi("LineNr",       { fg = k.dim1 })
hi("CursorLine",   { bg = k.dim2 })
hi("CursorLineNr", { fg = k.yellow, bg = k.dim2, bold = true })
hi("SignColumn",   { bg = k.bg })
hi("VertSplit",    { fg = k.dim1 })
hi("Visual",       { bg = k.sel })
hi("Search",       { fg = k.bg, bg = k.pink, bold = true })
hi("IncSearch",    { fg = k.bg, bg = k.violet, bold = true })

hi("StatusLine",   { fg = k.bg, bg = k.pink, bold = true })
hi("StatusLineNC", { fg = k.bg, bg = k.dim1 })
hi("WinSeparator", { fg = k.dim1 })

hi("Pmenu",        { fg = k.fg, bg = "#1a0822" }) -- close to color0
hi("PmenuSel",     { fg = k.bg, bg = k.blue, bold = true })
hi("PmenuSbar",    { bg = k.dim1 })
hi("PmenuThumb",   { bg = k.blue })

hi("Error",        { fg = k.red, bold = true })
hi("WarningMsg",   { fg = k.yellow })
hi("MoreMsg",      { fg = k.cyan })
hi("Question",     { fg = k.blue, bold = true })

hi("Comment",      { fg = k.dim1, italic = true })
hi("Constant",     { fg = k.cyan })
hi("String",       { fg = k.green })       -- bright cyan strings
hi("Character",    { fg = k.green })
hi("Number",       { fg = k.yellow })
hi("Boolean",      { fg = k.yellow })
hi("Identifier",   { fg = k.blue })
hi("Function",     { fg = k.magenta })
hi("Statement",    { fg = k.pink, bold = true })
hi("Keyword",      { fg = k.pink, italic = true })
hi("Operator",     { fg = k.red })
hi("Type",         { fg = k.violet })
hi("PreProc",      { fg = k.blue })
hi("Special",      { fg = k.purple })
hi("Todo",         { fg = k.bg, bg = k.violet, bold = true })

hi("@comment",         { link = "Comment" })
hi("@string",          { link = "String" })
hi("@number",          { link = "Number" })
hi("@boolean",         { link = "Boolean" })
hi("@constant",        { link = "Constant" })
hi("@constant.builtin",{ fg = k.cyan, bold = true })
hi("@variable",        { fg = k.fg })
hi("@variable.builtin",{ fg = k.blue, italic = true })
hi("@field",           { fg = k.fg })
hi("@property",        { fg = k.fg })
hi("@function",        { link = "Function" })
hi("@function.builtin",{ fg = k.magenta, italic = true })
hi("@type",            { link = "Type" })
hi("@keyword",         { link = "Keyword" })
hi("@operator",        { link = "Operator" })

hi("DiffAdd",    { fg = k.green })
hi("DiffChange", { fg = k.blue })
hi("DiffDelete", { fg = k.red })
hi("DiffText",   { fg = k.violet, bold = true })

hi("Cursor",     { fg = k.bg, bg = k.cur })
hi("VisualNOS",  { bg = k.sel })