-- credits:
--     src:  https://github.com/letieu/btw.nvim
--     src:  https://github.com/goolord/alpha-nvim
-- I took a loot of the code from 'btw' and some snippets from 'alpha', and dumb
-- it down. I don't want a menu, just a cool logo :)

-- NOTE: For now this plug is finished, maybe I will add some logos or texts,
--       but the core stuff is there
--
-- NOTE: plugin flow:
--       - logos and text are handled separately, though there’s no real
--         functional difference. You can add another module named "figs" to
--         store there some cool graphics and use them as "text" or "logo".
--       - users can add their own logos or text as needed; we just provide a
--         simple, minimal and really limited interface.
--       - we don’t add any functionality beyond aesthetics, if you want
--         buttons or shortcuts, you can use the FileType in an autocmd to set
--         up custom keymaps psudo-buttons.

local M = {}
local utils = require("beta.utils")
local texts = require("beta.texts")
local logos = require("beta.logos")
local presets = require("beta.presets")

---@enum Align
M.Align = {
    left   = "left",
    center = "center",
    right  = "right",
}

---@class Beta.Highlight
---@field logo string
---@field text string

---@class Beta.Align
---@field offset integer?
---@field style  Align

---@class Beta.Object
---@field lines     string[]
---@field hl        string?            override default hl
---@field box_lines boolean?           add spaces to make all lines same lenght
---@field align     Beta.Align?

---@alias Beta.Picker table<string, table<string, Beta.Object>>

---@class Beta.Preset
---@field logo          Beta.Object
---@field text          Beta.Object
---@field text_list     Beta.Object[]? array off text to randomly pick
---@field gap           integer

---@class Beta.Confing
---@field preset        Beta.Preset|string?
---@field logo          Beta.Object
---@field text          Beta.Object
---@field highlight     Beta.Highlight default hl
---@field text_list     Beta.Object[]? array off text to randomly pick
---@field gap           integer        gap between logo and text
---@field v_aling       number @float  [0.0, 1.0]; v_aling the content center
---@field opt_local     table<string, any>
---@field user_command  boolean?       generate user a user_cmd ":Beta"

---@type Beta.Confing
local def_conf = {
    preset = nil,
    logo = presets.minimal.logo, -- NOTE: need to do this ugly stuff instead of
    text = presets.minimal.text, --       preset = presets.minimal, because if
    gap  = presets.minimal.gap,  --       doesn't feel right to do it that way.
    v_aling = 0.5,
    highlight = { logo = "String", text = "Comment", },
    user_command = true,
    opt_local = {   -- NOTE: I don't know if this sould be "public" ._.
        ["bufhidden"]      = "wipe",
        ["buflisted"]      = false,
        ["buftype"]        = "nofile",
        ["colorcolumn"]    = '',
        ["cursorcolumn"]   = false,
        ["cursorline"]     = false,
        ["foldcolumn"]     = '0',
        ["foldlevel"]      = 999,
        ["list"]           = false,
        ["matchpairs"]     = "",
        ["modeline"]       = false,
        -- ["modifiable"]     = false,
        ["number"]         = false,
        ["readonly"]       = false,
        ["relativenumber"] = false,
        ["signcolumn"]     = 'no',
        ["spell"]          = false,
        ["swapfile"]       = false,
        ["synmaxcol"]      = 0,
        ["undofile"]       = false,
        ["wrap"]           = false,
    },
}
---@type Beta.Confing
M.config = {
    preset = nil,
    logo = logos.none,
    text = texts.none,
    text_list = nil,
    gap = 0,
    v_aling = 0.5,
    highlight = { logo = "NonText", text = "NonText", },
    user_command = true,
    opt_local = {},
}

local group = vim.api.nvim_create_augroup("Beta", {})

local align_map = {
    [M.Align.left]   = utils.align_left,
    [M.Align.right]  = utils.align_right,
    [M.Align.center] = utils.align_center,
}


-------------------------------------------------------------------------------

---@param  obj Beta.Object
---@return string[]
local gen_lines = function(obj)
    local lines = obj.lines
    if obj.align and align_map[obj.align.style] then
        lines = align_map[obj.align.style](lines, obj.align.offset)
    end
    return lines
end
--- @return string[], integer[]
local gen_render = function()
    local win_height = vim.api.nvim_win_get_height(0)
    local a1, a2, a3, a4

    local logo = gen_lines(M.config.logo)
    local text = gen_lines(M.config.text)

    -- NOTE: if the window is very small or the content_size too big, it may
    --       look off... maybe buy a bigger screen? ( OuO)
    local content_size = #logo + #text + M.config.gap
    local v_padding = math.floor(win_height * M.config.v_aling)
        - math.floor(content_size / 2)
    if v_padding < 0 then
        v_padding = 0
    elseif v_padding + content_size > win_height then
        v_padding = win_height - content_size
    end

    local lines = {}
    for _ = 1, v_padding do -- fill v_padding
        table.insert(lines, "")
    end; a1 = v_padding;

    for _, line in ipairs(logo) do -- logo
        table.insert(lines, line)
    end; a2 = a1 + #logo;

    a3 = a2
    for _ = 1, M.config.gap do -- mid gap
        table.insert(lines, ""); a3 = a3 + 1;
    end

    for _, line in ipairs(text) do -- text
        table.insert(lines, line)
    end; a4 = a3 + #text;

    for _ = 1, win_height - a4 do -- fill
        table.insert(lines, "")
    end

    return lines, { a1, a2 - 1, a3, a4 - 1 }
end

local can_we_act = function()
    if vim.fn.argc() > 0 then return false end

    for _, buf in pairs(vim.api.nvim_list_bufs()) do
        local bufinfo = vim.fn.getbufinfo(buf)
        if bufinfo.listed == 1 and #bufinfo.windows > 0 then
            return false
        end
    end

    return true
end

local render = function(buf)
    local lines, p = gen_render()

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local hl = M.config.logo.hl or M.config.highlight.logo
    for i = p[1], p[2] do
        vim.api.nvim_buf_add_highlight(buf, -1, hl, i, 0, -1)
    end
    hl = M.config.text.hl or M.config.highlight.text
    for i = p[3], p[4] do
        vim.api.nvim_buf_add_highlight(buf, -1, hl, i, 0, -1)
    end
end

local set_buf_cmds = function(buf)
    local au = function(event, callback, once, desc)
        return vim.api.nvim_create_autocmd(event, {
            group    = group,
            buffer   = buf,
            callback = callback,
            once     = once,
            desc     = desc
        })
    end

    local guicursor = vim.o.guicursor
    au("VimResized", function()
        render(buf)
    end, false, "Refresh beta buf")

    au("BufLeave", function()
        -- NOTE: the cursorline work if you use cursorline. The guicursor can
        --       lead to problems, if we go from a beta to another beta
        vim.o.guicursor = guicursor
        vim.cmd([[
                set cursorline
                hi Cursor blend=0
        ]])
    end, false, "Unhide cursor")

    au("BufEnter", function()
        vim.cmd([[
                set nocursorline
                hi Cursor blend=100
                set guicursor+=a:Cursor/lCursor
        ]])
    end, false, "Hide cursor on beta file")

    -- NOTE: autocmd.txt line 1274
    -- When a buffer is wiped out its buffer-local autocommands are also gone
    -- au("BufDelete", function() -- this is automatic becuase of
    --     for id in ipairs(autocmd_ids) do
    --         pcall(vim.api.nvim_del_autocmd, id)
    --     end
    -- end, true, "Delete autocmd")

    au("InsertEnter", function()
        vim.api.nvim_exec_autocmds("BufLeave", {
            group = M.group,
            buffer = buf,
        })
        pcall(vim.api.nvim_buf_delete, buf, {})
    end, true, "On InsertEnter close beta buf")
end

local set_local_opts = function(_)
    local eventignore = vim.opt.eventignore
    vim.opt.eventignore = 'all'

    for k, v in pairs(M.config.opt_local) do
        vim.opt_local[k] = v
    end

    vim.opt.eventignore = eventignore

    -- NOTE: need this, for shortcut stuff
    vim.opt_local["filetype"] = 'Beta'
end


-- API ------------------------------------------------------------------------

---@param on_vimenter boolean? if true will delete previous buff
M.open = function(on_vimenter)
    local prev_buf = vim.api.nvim_get_current_buf()
    local buf = vim.api.nvim_create_buf(false, true)

    local list = M.config.text_list -- select random text from list, if no_empty
    if list and #list > 0 then
        M.config.text = list[math.random(1, #list)]
    end

    set_buf_cmds(buf)

    render(buf)
    vim.api.nvim_set_current_buf(buf)

    set_local_opts(buf)

    if on_vimenter then
        pcall(vim.api.nvim_buf_delete, prev_buf, { force = true })
    end
end

M.setup = function(opts)
    opts = opts or {}
    -- NOTE: priority: def_conf << preset << opts
    if opts.preset then
        if type(opts.preset) == "string" then
            if not presets[opts.preset] then
                vim.api.nvim_err_writeln(string.format(
                    "beta:setup: theres not a preset named '%s', using 'minimal'",
                    opts.preset
                ))
                opts.preset = presets.minimal
            else
                opts.preset = presets[opts.preset]
            end
        end
        opts = vim.tbl_extend("keep", opts, opts.preset)
    end
    M.config = vim.tbl_extend("force", def_conf, opts)
    M.config.preset = nil

    -- setup text objets
    if M.config.logo.box_lines then
        M.config.logo.lines = utils.box_lines(M.config.logo.lines)
    end
    local list = M.config.text_list
    if list and #list > 0 then
        for _, obj in ipairs(M.config.text_list) do
            if obj.box_lines then
                obj.lines = utils.box_lines(obj.lines)
            end
        end
    else
        if M.config.text.box_lines then
            M.config.text.lines = utils.box_lines(M.config.text.lines)
        end
    end


    local on_vimenter = function() --- autocmd
        if can_we_act() then
            M.open(true)
        end
    end
    vim.api.nvim_create_autocmd("VimEnter", {
        group    = group,
        nested   = true,
        once     = true,
        callback = on_vimenter,
        desc     = "Open beta on VimEnter"
    })

    if M.config.user_command then --- user_cmd
        vim.api.nvim_create_user_command("Beta", M.open, { desc = "Pop a beta buf" })
    end
end

return M
