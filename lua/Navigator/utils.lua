local U = {}

---Executes a child process
---@param cmd string
---@return unknown
function U.execute(cmd)
    local handle = assert(io.popen(cmd .. ' 2>&1'), string.format('[Navigator] Unable to execute cmd - %q', cmd))
    local result = handle:read()
    handle:close()
    return result
end

local suffix_cache = nil
--Returns executable suffix based on platform
--- REF: Navigator.nvim
--@return string
U.suffix = function()
    if not suffix_cache then
        suffix_cache = '' -- default to empty, overwrite if it's windows
        local uname = vim.loop.os_uname()
        if string.find(uname.release, 'WSL.*$') or string.find(uname.sysname, '^Win') then -- may be windows
            if os.execute('wezterm.exe') == 0 then -- if exe exists, execute if expensive so heuristics first
                suffix_cache = '.exe'
            end
        end
        return suffix_cache
    end
end

return U
