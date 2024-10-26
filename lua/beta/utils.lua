local M = {}

-- Beta.Object stuff ----------------------------------------------------------

---@param  lines string[]
---@param  opts  table?
---@return Beta.Object
M.obj_base = function(lines, opts_def, opts)
    opts = vim.tbl_extend("force", opts_def, opts or {})
    opts.lines = lines
    return opts
end
-- picker<topic, <name, obj>> --(get topics)--> obj[]
---@param  picker table<string, table<string, Beta.Object>>
---@param  topics string|string[]
---@return Beta.Object[]
M.list_topics = function(picker, topics)
    local tbl = {}
    if type(topics) == "string" then
        topics = { topics }
    end
    for _, topic in ipairs(topics) do
        if not picker[topic] then goto continue end
        for _, v in pairs(picker[topic]) do
            table.insert(tbl, v)
        end
        :: continue ::
    end
    return tbl
end

-- misc -----------------------------------------------------------------------

-- ipairs wrapper to only return (v) instead of (i, v)
---@param  tabl table
---@return function
M.ipairs_wrapper = function(tabl)
    local i = 0
    return function()
        i = i + 1
        return tabl[i]
    end
end

-- string|string[] manipulation -----------------------------------------------

---@param str string
---@return integer
M.utf8_len = function(str)
    local len, i, str_len = 0, 1, #str
    while i <= str_len do
        len = len + 1
        local byte = string.byte(str, i)
        if byte >= 0xF0 then
            i = i + 4 -- 4-byte character
        elseif byte >= 0xE0 then
            i = i + 3 -- 3-byte character
        elseif byte >= 0xC0 then
            i = i + 2 -- 2-byte character
        else
            i = i + 1 -- 1-byte character (ASCII)
        end
    end
    return len
end
---@param lines string[]
---@return integer
M.get_max_len = function(lines)
    local max = -1
    for _, l in ipairs(lines) do
        local len = M.utf8_len(l)
        if max < len then
            max = len
        end
    end; return max
end

---@param text  string
---@param width integer
---@return string[]
M.separate_lines = function(text, width)
    local sep_lines, line = {}, ""

    for word in text:gmatch("%S+") do
        if #line + #word + 1 <= width then
            line = line == "" and word or line .. " " .. word
        else
            table.insert(sep_lines, line)
            line = word
        end
    end
    if #line > 0 then
        table.insert(sep_lines, line)
    end
    return sep_lines
end


---@param lines string[]
---@return string[]
M.box_lines = function(lines)
    local max_l = M.get_max_len(lines)
    local new_lines = {}
    for _, line in ipairs(lines) do
        table.insert(new_lines, line .. string.rep(" ", max_l - M.utf8_len(line)))
    end; return new_lines
end

---@param lines string[]
---@param n     integer
---@return string[]
M.padd_left = function(lines, n)
    local padding = string.rep(" ", n)
    local new_lines = {}
    for _, line in ipairs(lines) do
        table.insert(new_lines, padding .. line)
    end; return new_lines
end
---@param lines string[]
---@param n     integer
---@return string[]
M.padd_right = function(lines, n)
    local padding = string.rep(" ", n)
    local new_lines = {}
    for _, line in ipairs(lines) do
        table.insert(new_lines, line .. padding)
    end; return new_lines
end

---@param lines string[]
---@param n     integer? offset from left 0,+1,+2 (n>=0)
---@param _     integer? desired width, doesnt matter
---@return string[]
M.align_left = function(lines, n, _)
    -- NOTE: this works, because text by default is left aligned
    return M.padd_left(lines, n or 0)
end
---@param lines string[]
---@param n     integer? offset from right ...,-2,-1,width (n>=0)
---@param width integer? desired width, if null w=nvim_win_get_width(0)
---@return string[]
M.align_right = function(lines, n, width)
    local padding = ""
    width = width or vim.api.nvim_win_get_width(0)
    if n then
        width = width - n
        padding = string.rep(" ", n)
    end
    local new_lines = {}
    for _, line in ipairs(lines) do
        table.insert(new_lines,
            string.rep(" ", width - M.utf8_len(line)) .. line .. padding)
    end; return new_lines
end
---@param lines string[]
---@param n     integer? offset from center ...,-2,-1,width/2,+1,+2,...
---@param width integer? desired width, if null w=nvim_win_get_width(0)
---@return string[]
M.align_center = function(lines, n, width)
    n = n or 0
    width = width or vim.api.nvim_win_get_width(0)
    local new_lines = {}
    for _, line in ipairs(lines) do
        local hor_padding = math.floor((width - M.utf8_len(line)) / 2 + n)
        table.insert(new_lines, string.rep(" ", hor_padding) .. line)
    end; return new_lines
end

return M
