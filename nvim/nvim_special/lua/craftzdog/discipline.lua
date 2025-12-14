-- discipline.lua
-- Safe motion discipline for Neovim
-- Designed for long sessions, CTFs, CP, and security work
-- No leaks. No forced behavior. Fully controlled.

local M = {}

------------------------------------------------------------
-- Configuration
------------------------------------------------------------
local MAX_REPEAT = 12
local RESET_TIME = 1500
local ENABLED = true

------------------------------------------------------------
-- Internal state
------------------------------------------------------------
local counters = {}
local timers = {}

------------------------------------------------------------
-- Cleanup helper
------------------------------------------------------------
local function reset_key(key)
  counters[key] = 0
  if timers[key] then
    timers[key]:stop()
    timers[key]:close()
    timers[key] = nil
  end
end

------------------------------------------------------------
-- Notify safely
------------------------------------------------------------
local function notify(msg)
  pcall(vim.notify, msg, vim.log.levels.WARN, {
    title = "Discipline",
    timeout = 1200,
  })
end

------------------------------------------------------------
-- Core
------------------------------------------------------------
function M.cowboy()
  if not ENABLED then
    return
  end

  for _, key in ipairs({ "h", "j", "k", "l" }) do
    counters[key] = 0

    vim.keymap.set("n", key, function()
      if vim.v.count > 0 or vim.bo.buftype ~= "" then
        reset_key(key)
        return key
      end

      counters[key] = counters[key] + 1

      if counters[key] >= MAX_REPEAT then
        notify("Slow down. Use jumps or search.")
        reset_key(key)
        return key
      end

      if timers[key] then
        timers[key]:stop()
        timers[key]:close()
      end

      timers[key] = vim.uv.new_timer()
      timers[key]:start(RESET_TIME, 0, function()
        reset_key(key)
      end)

      return key
    end, { expr = true, silent = true })
  end
end

------------------------------------------------------------
-- Optional toggle
------------------------------------------------------------
function M.toggle()
  ENABLED = not ENABLED
  notify(ENABLED and "Discipline enabled" or "Discipline disabled")
end

return M
