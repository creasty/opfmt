local queries = require 'nvim-treesitter.query'
local parsers = require 'nvim-treesitter.parsers'
local ts_utils = require 'nvim-treesitter.ts_utils'

local M = {}

function M.get_space_count(mode)
  if mode == 3 then
    return 2
  elseif mode > 0 then
    return 1
  end
  return 0
end

function M.get_space_mode(left, right)
  if left and right then
    return 3
  elseif right then
    return 2
  elseif left then
    return 1
  end
  return 0
end

function M.format_space(token, mode)
  if mode == 1 or mode == 3 then
    token = ' ' .. token
  end
  if mode == 2 or mode == 3 then
    token = token .. ' '
  end
  return token
end

function M.match_patterns(str, patterns)
  if #patterns == 0 then
    return true
  end
  for _, pattern in ipairs(patterns) do
    if str:match(pattern) then
      return true
    end
  end
  return false
end

function M.match_rule(info, rule)
  if rule.tokens and not M.match_patterns(info.token, rule.tokens) then
    return false
  end
  if rule.ignore_paths and M.match_patterns(info.path, rule.ignore_paths) then
    return false
  end
  if rule.paths and not M.match_patterns(info.path, rule.paths) then
    return false
  end
  return true
end

function M.retrive_token_info_list(bufnr, line, row, col)
  if bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end

  local lang = parsers.get_buf_lang(bufnr)
  if not lang then
    return
  end

  if not parsers.has_parser(lang) then
    return
  end

  local lang_tree = parsers.get_parser(bufnr):language_for_range({ row, col, row, col })
  lang = lang_tree:lang()
  if not lang then
    return
  end

  local root = ts_utils.get_root_for_position(row, col, lang_tree)
  if not root then
    return
  end

  local query = queries.get_query(lang, 'opfmt')
  if not query then
    return
  end

  local range = { root:range() }
  local info_list = {}

  for _, match, metadata in query:iter_matches(root, bufnr, range[1], range[3] + 1) do
    local op_node
    for id, node in pairs(match) do
      if query.captures[id] == 'op' then
        op_node = node
        break
      end
    end

    if metadata.opfmt_space then
      local info = M.build_token_info(line, op_node)
      if info then
        info.lang = lang
        info.space_old = info.space
        info.space = metadata.opfmt_space
        table.insert(info_list, info)
      end
    end
  end

  return info_list
end

function M.build_token_info(line, node)
  local row1, col1, row2, col2 = node:range()
  if row1 ~= row2 then
    return
  end

  local token = string.sub(line, col1 + 1, col2)

  local sp_left = string.sub(line, col1, col1) == ' '
  if sp_left then
    col1 = col1 - 1
  end
  local sp_right = string.sub(line, col2 + 1, col2 + 1) == ' '
  if sp_right then
    col2 = col2 + 1
  end

  return {
    token = token,
    col_start = col1,
    col_end = col2,
    space = M.get_space_mode(sp_left, sp_right),
  }
end

function M.get_formatted_line(line, col, info_list, mode)
  local formatted = line

  for i = #info_list, 1, -1 do
    local info = info_list[i]

    if mode == 'around' then
      if math.min(math.abs(info.col_start - col), math.abs(info.col_end - col)) > 1 then
        goto continue
      end
    elseif mode == 'before' then
      if col <= info.col_start or col - info.col_end > 1 then
        goto continue
      end
    elseif mode == 'line' then
      -- noop
    else
      goto continue
    end

    local token = M.format_space(info.token, info.space)
    if info.space_old and info.col_end <= col then
      local shift = M.get_space_count(info.space) - M.get_space_count(info.space_old)
      col = col + shift
    end
    formatted = string.sub(formatted, 0, info.col_start) .. token .. string.sub(formatted, info.col_end + 1)

    ::continue::
  end

  return formatted, col
end

return M
