local queries = require 'nvim-treesitter.query'
local parsers = require 'nvim-treesitter.parsers'
local ts_utils = require 'nvim-treesitter.ts_utils'

local M = {}

function M.get_space_count(mod)
  if mod == 3 then
    return 2
  elseif mod > 0 then
    return 1
  end
  return 0
end

function M.get_space_mod(left, right)
  if left and right then
    return 3
  elseif right then
    return 2
  elseif left then
    return 1
  end
  return 0
end

function M.format_space(text, mod)
  if mod == 1 or mod == 3 then
    text = ' ' .. text
  end
  if mod == 2 or mod == 3 then
    text = text .. ' '
  end
  return text
end

function M.find_tokens(bufnr, line, row, col)
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
  local tokens = {}

  for _, _, metadata in query:iter_matches(root, bufnr, range[1], range[3] + 1) do
    local op_node_row = metadata.opfmt_node:start()
    if op_node_row == row and metadata.opfmt_space then
      local token = M.build_token(line, metadata.opfmt_node)
      if token then
        token.lang = lang
        token.space_old = token.space
        token.space = metadata.opfmt_space
        table.insert(tokens, token)
      end
    end
  end

  return tokens
end

function M.node_normalized_range(node, eol)
  local row1, col1, row2, col2 = node:range()
  if row2 == row1 + 1 and col2 == 0 then
    row2 = row1
    col2 = eol
  end
  return row1, col1, row2, col2
end

function M.build_token(line, node)
  local eol = string.len(line)
  local row1, col1, row2, col2 = M.node_normalized_range(node, eol)
  if row1 ~= row2 then
    return
  end

  local text = string.sub(line, col1 + 1, col2)

  local sp_left = string.sub(line, col1, col1) == ' '
  if sp_left then
    col1 = col1 - 1
  end
  local sp_right = string.sub(line, col2 + 1, col2 + 1) == ' '
  if sp_right then
    col2 = col2 + 1
  end

  local ignored = false
  local parent = node:parent()
  if parent then
    if parent:has_error() then
      ignored = 'parent_error'
    else
      -- local p_row1, _, p_row2, _ = M.node_normalized_range(parent)
      -- if not (row1 == p_row1 and p_row1 == p_row2) then
      --   ignored = 'multiline'
      -- end
    end
  end

  return {
    text = text,
    col_start = col1,
    col_end = col2,
    space = M.get_space_mod(sp_left, sp_right),
    ignored = ignored,
  }
end

function M.get_formatted_line(line, col, tokens, mode)
  local formatted = line

  for i = #tokens, 1, -1 do
    local token = tokens[i]

    if token.ignored then
      goto continue
    end

    if mode == 'around' then
      if math.min(math.abs(token.col_start - col), math.abs(token.col_end - col)) > 1 then
        goto continue
      end
    elseif mode == 'before' then
      if col <= token.col_start or col - token.col_end > 1 then
        goto continue
      end
    elseif mode == 'line' then
      -- noop
    else
      goto continue
    end

    local text = M.format_space(token.text, token.space)
    if token.space_old and token.col_end <= col then
      local shift = M.get_space_count(token.space) - M.get_space_count(token.space_old)
      col = col + shift
    end
    formatted = string.sub(formatted, 0, token.col_start) .. text .. string.sub(formatted, token.col_end + 1)

    ::continue::
  end

  return formatted, col
end

return M
