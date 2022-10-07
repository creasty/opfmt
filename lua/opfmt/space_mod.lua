local M = {}

function M.pack(left, right)
  if left and right then
    return 3
  elseif right then
    return 2
  elseif left then
    return 1
  end
  return 0
end

function M.unpack(mod)
  local left = mod == 1 or mod == 3
  local right = mod == 2 or mod == 3
  return left, right
end

function M.space_mod_sub(a, b)
  local al, ar = M.unpack(a)
  local bl, br = M.unpack(b)
  return M.pack(al and bl, ar and br)
end

function M.space_mod_add(a, b)
  local al, ar = M.unpack(a)
  local bl, br = M.unpack(b)
  return M.pack(al or bl, ar or br)
end

function M.count(mod)
  local l, r = M.unpack(mod)
  if l and r then
    return 3
  elseif l or r then
    return 1
  end
  return 0
end

function M.format(text, mod)
  local l, r = M.unpack(mod)
  if l then
    text = ' ' .. text
  end
  if r then
    text = text .. ' '
  end
  return text
end

return M
