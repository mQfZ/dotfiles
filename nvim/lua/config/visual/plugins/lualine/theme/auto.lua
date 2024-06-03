local contrast_threshold = 0.2
local contrast_step = 5
local contrast_iterations = 15
local brightness_modifier_value = 0.0

local colors = {
  normal = util.Color.from_highlight_list("fg", { "PreProc", "Include" }),
  insert = util.Color.from_highlight_list("fg", { "String", "MoreMsg" }),
  replace = util.Color.from_highlight_list("fg", { "Number", "Type" }),
  visual = util.Color.from_highlight_list("fg", { "Special", "Boolean", "Constant" }),
  command = util.Color.from_highlight_list("fg", { "Conditional", "Statment" }),
  back = util.Color.from_highlight_list("bg", { "StatusLine" }),
}

local normal = util.Color.from_highlight("bg", "Normal")
if normal ~= nil then
  if normal:brightness() > 0.5 then
    brightness_modifier_value = -brightness_modifier_value
  end
  for name, color in pairs(colors) do
    if color ~= nil then
      colors[name] = color:brightness_modifier(brightness_modifier_value)
    end
  end
end

local hl = {}
for name, color in pairs(colors) do
  if color ~= nil then
    hl[name] = color:to_num()
  end
end

local theme = {
  normal = {
    a = { bg = hl.normal, fg = hl.back, gui = "bold" },
    b = { bg = hl.back, fg = hl.normal },
    c = { bg = hl.back },
  },
  insert = {
    a = { bg = hl.insert, fg = hl.back, gui = "bold" },
    b = { bg = hl.back, fg = hl.insert },
    c = { bg = hl.back },
  },
  replace = {
    a = { bg = hl.replace, fg = hl.back, gui = "bold" },
    b = { bg = hl.back, fg = hl.replace },
    c = { bg = hl.back },
  },
  visual = {
    a = { bg = hl.visual, fg = hl.back, gui = "bold" },
    b = { bg = hl.back, fg = hl.visual },
    c = { bg = hl.back },
  },
  command = {
    a = { bg = hl.command, fg = hl.back, gui = "bold" },
    b = { bg = hl.back, fg = hl.command },
    c = { bg = hl.back },
  },
  terminal = {
    a = { bg = hl.command, fg = hl.back, gui = "bold" },
    b = { bg = hl.back, fg = hl.terminal },
    c = { bg = hl.back },
  },
  inactive = {
    a = { bg = hl.normal, fg = hl.back, gui = "bold" },
    b = { bg = hl.back, fg = hl.inactive },
    c = { bg = hl.back },
  },
}

for _, section in pairs(theme) do
  for _, highlight in pairs(section) do
    if highlight.bg and highlight.fg then
      util.Color.apply_contrast(highlight, contrast_threshold, contrast_step, contrast_iterations)
    end

    ---@diagnostic disable-next-line: param-type-mismatch
    highlight.bg = highlight.bg and util.Color.from_num(highlight.bg):to_str() or nil
    ---@diagnostic disable-next-line: param-type-mismatch
    highlight.fg = highlight.fg and util.Color.from_num(highlight.fg):to_str() or nil
  end
end

return theme
