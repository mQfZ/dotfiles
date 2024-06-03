---@class util.Color
---@field red number
---@field green number
---@field blue number
local Color = {}

---@param red number
---@param green number
---@param blue number
---@return util.Color
function Color.new(red, green, blue)
  local self = setmetatable({}, { __index = Color })
  self.red = red
  self.green = green
  self.blue = blue
  return self
end

---@param rgb_str string
---@return self
function Color.from_str(rgb_str)
  if rgb_str:find("#") == 1 then
    rgb_str = rgb_str:sub(2, #rgb_str)
  end
  local red = tonumber(rgb_str:sub(1, 2), 16)
  local green = tonumber(rgb_str:sub(3, 4), 16)
  local blue = tonumber(rgb_str:sub(5, 6), 16)
  return Color.new(red, green, blue)
end

---@return string
function Color:to_str()
  return string.format("#%02x%02x%02x", self.red, self.green, self.blue)
end

---@param rgb_num number
---@return self
function Color.from_num(rgb_num)
  local red = bit.band(bit.rshift(rgb_num, 16), 0xFF)
  local green = bit.band(bit.rshift(rgb_num, 8), 0xFF)
  local blue = bit.band(rgb_num, 0xFF)
  return Color.new(red, green, blue)
end

---@return number
function Color:to_num()
  return bit.lshift(self.red, 16) + bit.lshift(self.green, 8) + self.blue
end

---@return number
function Color:brightness()
  return (self.red * 2 + self.green * 3 + self.blue) / 1536
end

---@return number
function Color:average()
  return (self.red + self.green + self.blue) / 768
end

local function clamp(val, left, right)
  if val > right then
    return right
  end
  if val < left then
    return left
  end
  return val
end

---@param value number
---@return self
function Color:brightness_modifier(value)
  local red = clamp(self.red + (self.red * value), 0, 255)
  local green = clamp(self.green + (self.green * value), 0, 255)
  local blue = clamp(self.blue + (self.blue * value), 0, 255)
  return Color.new(red, green, blue)
end

---@param value number
---@return self
function Color:contrast_modifier(value)
  local red = clamp(self.red + value, 0, 255)
  local green = clamp(self.green + value, 0, 255)
  local blue = clamp(self.blue + value, 0, 255)
  return Color.new(red, green, blue)
end

---@param attr string
---@param highlight_name string
---@return self?
function Color.from_highlight(attr, highlight_name)
  local highlight = vim.api.nvim_get_hl(0, { name = highlight_name, link = false })
  if highlight.reverse then
    if attr == "fg" then
      attr = "bg"
    elseif attr == "bg" then
      attr = "fg"
    end
  end
  return highlight[attr] and Color.from_num(highlight[attr]) or nil
end

---@param attr string
---@param highlight_names string[]
---@return self?
function Color.from_highlight_list(attr, highlight_names)
  for _, highlight_name in pairs(highlight_names) do
    local color = Color.from_highlight(attr, highlight_name)
    if color then
      return color
    end
  end
  return nil
end

---@param highlight vim.api.keyset.hl_info
---@param threshold? number
---@param step? number
---@param iterations? number
---@return nil
function Color.apply_contrast(highlight, threshold, step, iterations)
  threshold = clamp(threshold or 0.3, 0, 0.5)
  step = math.abs(step or 5)
  iterations = iterations or 10

  if highlight.bg == nil or highlight.fg == nil then
    return
  end
  local bg = Color.from_num(highlight.bg)
  local fg = Color.from_num(highlight.fg)
  if bg:average() > fg:average() then
    step = -step
  end

  local iteration = 10
  while math.abs(bg:average() - fg:average()) < threshold and iteration < iterations do
    fg = fg:contrast_modifier(step)
    iteration = iteration + 1
  end

  highlight.bg = bg:to_num()
  highlight.fg = fg:to_num()
end

return Color
