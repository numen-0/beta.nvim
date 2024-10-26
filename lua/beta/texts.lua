local utils = require("beta.utils")
local M = {}


local opt_t = {
    box_lines = false,
    align     = { offset = 0, style = "center" },
}
local opt_quote = {
    box_lines = false,
    align     = { offset = 0, style = "center" },
}

local function t(lines, opts)
    return utils.obj_base(lines, opt_t, opts)
end
local function quote_t(lines, opts)
    return utils.obj_base(lines, opt_quote, opts)
end
---@param  text   string|string[]
---@param  author string
---@param  opts   table?
---@return Beta.Object
local function quote(text, author, opts)
    local lines = {}
    local iter, len = nil, 0
    -- local len = 64
    local is_string = type(text) == "string"

    if is_string then
        ---@diagnostic disable-next-line: param-type-mismatch
        iter = text:gmatch("([^\n]*)\n?")
    else
        ---@diagnostic disable-next-line: param-type-mismatch
        iter = utils.ipairs_wrapper(text)
    end
    for line in iter do
        -- table.insert(lines, string.rep(" ", len - #line) .. line)
        table.insert(lines, line)
        local l = utils.utf8_len(line)
        if l > len then
            len = l
        end

    end
    if author then
        if is_string then table.remove(lines, #lines) end -- chop excess
        local l = utils.utf8_len(author)
        table.insert(lines, string.rep(" ", len - l) .. author)
    end

    return quote_t(lines, opts)
end
---@param  text   string
---@param  author string
---@param  opts   table?
---@return Beta.Object
local function quote_str(text, author, len, opts)
    local lines = {}
    local iter

    iter = utils.ipairs_wrapper(utils.separate_lines(text, len))

    for line in iter do
        local l = utils.utf8_len(line)
        table.insert(lines, string.rep(" ", len - l) .. line)
    end
    if author then
        local l = utils.utf8_len(author)
        table.insert(lines, string.rep(" ", len - l) .. author)
    end

    return quote_t(lines, opts)
end

---@type Beta.Object
M.none   = {
    lines     = {},
    hl        = "NonText",
    box_lines = false,
    align     = nil,
}

---@type Beta.Picker
M.picker = {
    misc = {
        btw = t({
            [[btw]],
        }, {}),
    },
    quotes = {
        terry_q  = quote([["An idiot admires complexity, a genius admires simplicity"]],
            "Terry A. Davis"),
        jordan_q = quote([["Always tell the truth, or at least don’t lie"]],
            "Jordan Peterson"),
    },
    one_piece = {
        brook_q     = quote([["Death is never an apology."]], "Brook"),
        zoro_q      = quote([["If I die here, then I’m a man that could only make it this far."]],
            "Roronoa Zoro"),
        drhiluluk_q = quote([[
"When do you think people die? When they are shot through the
heart by the bullet of a pistol? No. When they are ravaged by
an incurable disease? No. When they drink a soup made from a
poisonous mushroom!? No! It’s when... they are forgotten.”
]], "Dr. Hiluluk", { align = { offset = 0, style = "center" }, box_lines = true })
    },
    kung_fu_panda = {
        po_q = quote([["There is no secret ingredient, it’s just you"]],
            "Po"),
        shifu_q1 = quote([["Time is an illusion, there is only the now"]],
            "Master Shifu"),
        shifu_q2 = quote([["The mark of a true hero is humility"]],
            "Master Shifu"),
        shifu_q3 = quote([["If you only do what you can do, you will never be more than who you are now"]],
            "Master Shifu"),
        oogway_q1 = quote([["There are no accidents"]],
            "Master Ooway"),
        oogway_q2 = quote([["You are too concerned with what was and what will be"]],
            "Master Ooway"),
        oogway_q3 = quote_str([["Yesterday is history, tomorrow is a mystery, but today is a gift. That is why it is called the present"]],
            "Master Ooway", 64),
        oogway_q4 = quote_str([["Your mind is like this water, my friend. When it is agitated, it becomes difficult to see. But if you allow it to settle, the answer becomes clear"]],
            "Master Ooway", 64),
        oogway_q5 = quote([["There is just news. There is no good or bad"]],
            "Master Ooway"),
        oogway_q6 = quote([["The more you take, the less you have"]],
            "Master Ooway"),
        ping_q1 = quote([["To make something special you just have to believe it's special"]],
            "Mr. Ping"),
    }
}

return M
