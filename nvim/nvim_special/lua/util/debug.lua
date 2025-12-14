-- debug.lua
-- Safe debugging helpers for Neovim
-- CTF / CP / Red Team / Pentesting friendly
-- No globals. No crashes. No leaks.

local M = {}

------------------------------------------------------------
-- Internal helpers
------------------------------------------------------------
local function safe_notify(msg, title)
  pcall(vim.notify, msg, vim.log.levels.INFO, {
    title = title or "Debug",
  })
end

------------------------------------------------------------
-- Get caller location safely
------------------------------------------------------------
function M.get_loc()
  local level = 3
  while true do
    local info = debug.getinfo(level, "S")
    if not info then
      break
    end
    if info.what == "Lua" and info.source and not info.source:match("vim/env") then
      local src = info.source:gsub("^@", "")
      src = vim.loop.fs_realpath(src) or src
      return string.format("%s:%d", src, info.linedefined or 0)
    end
    level = level + 1
  end
  return "unknown"
end

------------------------------------------------------------
-- Dump value safely
------------------------------------------------------------
function M.dump(value, opts)
  opts = opts or {}
  opts.loc = opts.loc or M.get_loc()

  if vim.in_fast_event() then
    return vim.schedule(function()
      M.dump(value, opts)
    end)
  end

  local msg = vim.inspect(value)
  local title = "Debug: " .. vim.fn.fnamemodify(opts.loc, ":~:.")

  safe_notify(msg, title)
end

------------------------------------------------------------
-- Namespace extmark inspection
------------------------------------------------------------
function M.extmark_leaks()
  local namespaces = vim.api.nvim_get_namespaces()
  local results = {}

  for name, ns in pairs(namespaces) do
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        local count = #vim.api.nvim_buf_get_extmarks(buf, ns, 0, -1, {})
        if count > 0 then
          results[#results + 1] = {
            namespace = name,
            buffer = buf,
            count = count,
            filetype = vim.bo[buf].filetype,
          }
        end
      end
    end
  end

  table.sort(results, function(a, b)
    return a.count > b.count
  end)

  M.dump(results, { loc = "extmark_leaks" })
end

------------------------------------------------------------
-- Safe size estimation
------------------------------------------------------------
local function estimate_size(value, visited)
  if value == nil then
    return 0
  end

  visited = visited or {}
  if visited[value] then
    return 0
  end
  visited[value] = true

  local t = type(value)

  if t == "boolean" then
    return 4
  elseif t == "number" then
    return 8
  elseif t == "string" then
    return #value + 24
  elseif t == "function" then
    return 64
  elseif t == "table" then
    local size = 64
    for k, v in pairs(value) do
      size = size + estimate_size(k, visited)
      size = size + estimate_size(v, visited)
    end
    return size
  end

  return 0
end

------------------------------------------------------------
-- Loaded module memory inspection
------------------------------------------------------------
function M.module_leaks(filter)
  local sizes = {}

  for name, mod in pairs(package.loaded) do
    if not filter or name:match(filter) then
      local root = name:match("^([^%.]+)") or name
      sizes[root] = sizes[root] or { module = root, size = 0 }
      sizes[root].size = sizes[root].size + estimate_size(mod) / 1024 / 1024
    end
  end

  local list = vim.tbl_values(sizes)
  table.sort(list, function(a, b)
    return a.size > b.size
  end)

  M.dump(list, { loc = "module_leaks" })
end

------------------------------------------------------------
-- Get function upvalue safely
------------------------------------------------------------
function M.get_upvalue(func, name)
  if type(func) ~= "function" then
    return nil
  end

  local i = 1
  while true do
    local n, v = debug.getupvalue(func, i)
    if not n then
      break
    end
    if n == name then
      return v
    end
    i = i + 1
  end
  return nil
end

return M
