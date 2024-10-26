local utils = require("beta.utils")

local opt_t = {
    -- hl        = "Constant",
    box_lines = false,
    align     = { offset = 0, style = "center" },
}
---@param  lines string[]
---@param  opts  table?
---@return Beta.Object
local function t(lines, opts)
    return utils.obj_base(lines, opt_t, opts)
end


---@type Beta.Object[]
local M = {
    none           = {
        lines     = {},
        hl        = "NonText",
        box_lines = false,
        align     = nil,
    },
    -- http://www.patorjk.com/software/taag/#p=testall&f=Graffiti&t=NeoVim.
    -- Font Name: tmplr
    -- *modified*
    -- https://www.fileformat.info/info/unicode/block/box_drawing/list.htm
    minimal        = t({
        [[┳┓    ┓┏•    ]],
        [[┃┃┏┓┏┓┃┃┓┏┳┓ ]],
        [[┛┗┗ ┗┛┗┛┗┛╹┗•]],
    }),
    -- src: https://github.com/goolord/alpha-nvim/discussions/16?sort=top#discussioncomment-3064967
    neo            = t({
        [[                                                                     ]],
        [[      ████ ██████           █████      ██                      ]],
        [[     ███████████             █████                              ]],
        [[     █████████ ███████████████████ ███   ███████████    ]],
        [[    █████████  ███    █████████████ █████ ██████████████    ]],
        [[   █████████ ██████████ █████████ █████ █████ ████ █████    ]],
        [[ ███████████ ███    ███ █████████ █████ █████ ████ █████   ]],
        [[██████  █████████████████████ ████ █████ █████ ████ ██████]],
    }),
    neo_underlined = t({
        [[                                                                         ]],
        [[        ████ ██████           █████      ██                        ]],
        [[       ███████████             █████                                ]],
        [[       █████████ ███████████████████ ███   ███████████      ]],
        [[      █████████  ███    █████████████ █████ ██████████████      ]],
        [[     █████████ ██████████ █████████ █████ █████ ████ █████      ]],
        [[   ███████████ ███    ███ █████████ █████ █████ ████ █████     ]],
        [[  ██████  █████████████████████ ████ █████ █████ ████ ██████  ]],
        [[                                                                           ]],
        [[▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀]],
    }),
    -- src: https://github.com/goolord/alpha-nvim/discussions/16?sort=new#discussioncomment-10062303
    -- *modified*
    big_n          = t({
        [[   ███        ███  ]],
        [[   ████       ████ ]],
        [[  ████      █████ ]],
        [[ ██ ████     █████ ]],
        [[ ███ ████    █████ ]],
        [[ ████ ████   █████ ]],
        [[ █████  ████  █████ ]],
        [[ █████   ████ ████ ]],
        [[ █████    ████ ███ ]],
        [[ █████     ████ ██ ]],
        [[ █████      ████  ]],
        [[ ████       ████   ]],
        [[  ███        ███   ]],
        [[                      ]],
        [[   N  E  O  V  I  M   ]],
    }),
    big_n_head     = t({
        [[   ███        ███  ]],
        [[   ████       ████ ]],
        [[  ████      █████ ]],
        [[ ██ ████     █████ ]],
        [[ ███ ████    █████ ]],
        [[ ████ ████   █████ ]],
        [[ █████  ████  █████ ]],
        [[ █████   ████ ████ ]],
        [[ █████    ████ ███ ]],
        [[ █████     ████ ██ ]],
        [[ █████      ████  ]],
        [[ ████       ████   ]],
        [[  ███        ███   ]],
    }),
    big_n_foot     = t({
        [[   N  E  O  V  I  M   ]],
    }),
    -- NOTE: this is only to remind me that this was supposed to be a "quick
    --       one-day project"
    -- src: https://www.asciiart.eu/computers/other
    -- *highly modified*
    hour_glass     = t({
        [[                            ____         ]],
        [[        ____....----''''````    |.       ]],
        [[,'''````            ____....----; '.     ]],
        [[| __....----''''````         .-.`'. '.   ]],
        [[|.-.    ,_____.--------______| |_  '. '. ]],
        [[`| |   ;,-------._______.----| |-; .-;. |]],
        [[ | |`'-: !-------------------| |,:.| |-=']],
        [[ | |   : !                   | |.: | |   ]],
        [[ | |   : !              _,,;;| |#: | |   ]],
        [[ | |   : !       _,,;########| |#: | |   ]],
        [[ | |   |:!    ,;#############| |;' | |   ]],
        [[ | |   |:! _,################| |'  | |   ]],
        [[ | |   | :;###############***| |   | |   ]],
        [[ | |   | |;##########********| |   | |   ]],
        [[ | |   | | ;****************;| |   | |   ]],
        [[ | |   | |  ;**************;'| |   | |   ]],
        [[ | |   | |   :************:' | |   | |   ]],
        [[ | |   | |    .:********;'   | |   | |   ]],
        [[ | |   | |      ':*****;'    | |   | |   ]],
        [[ | |   | |        ';*;'      | |   | |   ]],
        [[ | |   | |       ,:'*':,     | |   | |   ]],
        [[ | |   | |    .:'   *   ':.  | |   | |   ]],
        [[ | |   | |   :      *      : | |   | |   ]],
        [[ | |   | |  :       *       :| |   | |   ]],
        [[ | |   | | :        *        | |   | |   ]],
        [[ | |   | |:         *        | |   | |   ]],
        [[ | |   | |:         *        | |   | |   ]],
        [[ | |   | :          *        | |   | |   ]],
        [[ | |   |:!          * *      | |   | |   ]],
        [[ | |   |:!       ,,;**       | |.  | |   ]],
        [[ | |   : !```'''*********__  | |:  | |   ]],
        [[ | | ,`: |  _,************ ``| |:--| |-..]],
        [[ | |'  :_.-*****************-| |:  '-' ,|]],
        [[ | |   :  ******************:| |'    .' |]],
        [[,;-'_   `-._**************.-'| |   .'  .']],
        [[|    ````'''----....___-'    '-' .'  .'  ]],
        [['---....____           ````'''--;  ,'    ]],
        [[            ````''''----....____|.'      ]],
    }),
    -- test    = t({
    --     [[new logo]]
    -- }, { box_lines = true }),
}

return M