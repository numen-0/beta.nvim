local logos = require("beta.logos")
local texts = require("beta.texts")
local utils = require("beta.utils")
---@type table<string, Beta.Preset>
local M = {}

M = {
    none = {
        logo = logos.none,
        text = texts.none,
        text_list = nil,
        gap = 0,
    },
    minimal = {
        logo = logos.minimal,
        text = texts.picker.misc.btw,
        text_list = nil,
        gap = 0,
    },
    basic = {
        logo = logos.neo,
        text = texts.picker.quotes.terry_q,
        text_list = nil,
        gap = 1,
    },
    big_n = {
        logo = logos.big_n,
        text = texts.none,
        text_list = nil,
        gap = 0,
    },
    mix = {
        logo = logos.big_n_head,
        text = texts.none,
        text_list = utils.list_topics(texts.picker, {
            "misc",
            "quotes",
            "one_piece",
            "kung_fu_panda",
        }),
        gap = 1,
    }
}

return M
