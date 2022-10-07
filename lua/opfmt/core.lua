local queries = require 'nvim-treesitter.query'
local parsers = require 'nvim-treesitter.parsers'
local ts_utils = require 'nvim-treesitter.ts_utils'
local space_mod = require 'opfmt.space_mod'

local M = {}

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
        token.space_old = token.space
        token.space = space_mod.add(token.space, metadata.opfmt_space)
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

  local sp_l = string.sub(line, col1, col1) == ' '
  if sp_l then
    col1 = col1 - 1
  end
  local sp_r = string.sub(line, col2 + 1, col2 + 1) == ' '
  if sp_r then
    col2 = col2 + 1
  end

  local ignored = false
  local parent = node:parent()
  if parent then
    if parent:has_error() then
      ignored = 'parent_error'
    end
  end

  return {
    text = text,
    col_start = col1,
    col_end = col2,
    space = space_mod.pack(sp_l, sp_r),
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

    local sp_l, sp_r = space_mod.unpack(token.space)

    if token.col_start == 1 then
      -- Avoid leading spaces
      sp_l = false
    elseif token.col_end == #line then
      -- Avoid trailing spaces
      sp_r = false
    end

    local prev_token = tokens[i + 1]
    if prev_token and prev_token.col_start == token.col_end then
      local l, _ = space_mod.unpack(prev_token.space)
      sp_r = sp_r and (not l)
    end

    token.space = space_mod.pack(sp_l, sp_r)

    local text = space_mod.format(token.text, token.space)
    if token.space_old and token.col_end <= col then
      local shift = space_mod.count(token.space) - space_mod.count(token.space_old)
      col = col + shift
    end
    formatted = string.sub(formatted, 0, token.col_start) .. text .. string.sub(formatted, token.col_end + 1)

    ::continue::
  end

  return formatted, col
end

return M
