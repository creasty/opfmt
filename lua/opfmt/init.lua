local queries = require 'nvim-treesitter.query'
local parsers = require 'nvim-treesitter.parsers'

local M = {}

local function is_supported(lang)
  local seen = {}

  local function has_nested_opfmt(nested_lang)
    if not parsers.has_parser(nested_lang) then
      return false
    end
    if queries.has_query_files(nested_lang, 'opfmt') then
      return true
    end
    if seen[nested_lang] then
      return false
    end
    seen[nested_lang] = true

    if queries.has_query_files(nested_lang, 'injections') then
      local query = queries.get_query(nested_lang, 'injections')
      for _, capture in ipairs(query.info.captures) do
        if capture == 'language' or has_nested_opfmt(capture) then
          return true
        end
      end
    end

    return false
  end

  return has_nested_opfmt(lang)
end

local function set_opfmt(match, _pattern, _bufnr, predicate, metadata)
  metadata.opfmt_node = match[predicate[2]]
  metadata.opfmt_space = tonumber(predicate[3])
end

function M.init()
  require('nvim-treesitter').define_modules {
    opfmt = {
      module_path = 'opfmt.internal',
      enable = false,
      disable = {},
      is_supported = is_supported,
    }
  }

  vim.treesitter.query.add_directive('opfmt!', set_opfmt)
end

return M
