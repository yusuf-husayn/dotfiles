-- hsl.lua
-- Safe color utilities for Neovim
-- Supports hex, rgb, hsl
-- Stable for CTF, CP, Web, and security work

local M = {}

------------------------------------------------------------
-- Utilities
------------------------------------------------------------
local function clamp(v, min, max)
  return math.min(math.max(v, min), max)
end

------------------------------------------------------------
-- HEX → RGB
-- Supports #rgb and #rrggbb
------------------------------------------------------------
function M.hex_to_rgb(hex)
  hex = hex:lower():gsub("#", "")

  if #hex == 3 then
    hex = hex:gsub(".", "%0%0")
  end

  if #hex ~= 6 then
    return nil
  end

  local r = tonumber(hex:sub(1, 2), 16)
  local g = tonumber(hex:sub(3, 4), 16)
  local b = tonumber(hex:sub(5, 6), 16)

  if not r or not g or not b then
    return nil
  end

  return r / 255, g / 255, b / 255
end

------------------------------------------------------------
-- RGB → HSL
------------------------------------------------------------
function M.rgb_to_hsl(r, g, b)
  local max = math.max(r, g, b)
  local min = math.min(r, g, b)
  local h, s, l = 0, 0, (max + min) / 2

  if max ~= min then
    local d = max - min
    s = l > 0.5 and d / (2 - max - min) or d / (max + min)

    if max == r then
      h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
      h = (b - r) / d + 2
    else
      h = (r - g) / d + 4
    end

    h = h / 6
  end

  return h * 360, s * 100, l * 100
end

------------------------------------------------------------
-- HSL → RGB
------------------------------------------------------------
function M.hsl_to_rgb(h, s, l)
  h = h / 360
  s = s / 100
  l = l / 100

  local function hue2rgb(p, q, t)
    if t < 0 then t = t + 1 end
    if t > 1 then t = t - 1 end
    if t < 1 / 6 then return p + (q - p) * 6 * t end
    if t < 1 / 2 then return q end
    if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
    return p
  end

  if s == 0 then
    return l, l, l
  end

  local q = l < 0.5 and l * (1 + s) or l + s - l * s
  local p = 2 * l - q

  return
    hue2rgb(p, q, h + 1 / 3),
    hue2rgb(p, q, h),
    hue2rgb(p, q, h - 1 / 3)
end

------------------------------------------------------------
-- RGB → HEX
------------------------------------------------------------
function M.rgb_to_hex(r, g, b)
  return string.format(
    "#%02x%02x%02x",
    clamp(math.floor(r * 255 + 0.5), 0, 255),
    clamp(math.floor(g * 255 + 0.5), 0, 255),
    clamp(math.floor(b * 255 + 0.5), 0, 255)
  )
end

------------------------------------------------------------
-- HEX → HSL string
------------------------------------------------------------
function M.hex_to_hsl_string(hex)
  local rgb = M.hex_to_rgb(hex)
  if not rgb then
    return nil
  end

  local h, s, l = M.rgb_to_hsl(rgb)
  return string.format(
    "hsl(%d, %d%%, %d%%)",
    math.floor(h + 0.5),
    math.floor(s + 0.5),
    math.floor(l + 0.5)
  )
end

------------------------------------------------------------
-- Replace hex with HSL
-- Works on visual selection or current line
------------------------------------------------------------
function M.replace_hex_with_hsl()
  local buf = vim.api.nvim_get_current_buf()
  local mode = vim.fn.mode()

  local start_line, end_line

  if mode:match("[vV]") then
    start_line = vim.fn.line("'<") - 1
    end_line = vim.fn.line("'>")
  else
    local line = vim.api.nvim_win_get_cursor(0)[1]
    start_line = line - 1
    end_line = line
  end

  local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)

  for i, line in ipairs(lines) do
    lines[i] = line:gsub("#%x%x%x%x%x%x", function(hex)
      return M.hex_to_hsl_string(hex) or hex
    end):gsub("#%x%x%x", function(hex)
      return M.hex_to_hsl_string(hex) or hex
    end)
  end

  vim.api.nvim_buf_set_lines(buf, start_line, end_line, false, lines)
end

return M
