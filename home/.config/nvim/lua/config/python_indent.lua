-- LeetCode-style Python indentation. A new line keeps the indent of the line
-- above, plus one level after a line ending in ":" or an opening bracket.
-- Nothing dedents by itself (not after `return`/`break`, not while typing
-- `else:`); Shift+Tab does that. Tree-sitter's Python indent guesses instead,
-- and mid-edit code throws its guesses off.
local M = {}

-- The line's code with any trailing comment and whitespace removed. A "#" is
-- only treated as a comment when no quote follows it, so "#" inside a string
-- doesn't hide a colon or bracket after it.
local function code(line)
  return (line:gsub("%s*#[^'\"]*$", ""):gsub("%s+$", ""))
end

function M.indentexpr()
  local lnum = vim.v.lnum
  local prev = vim.fn.prevnonblank(lnum - 1)
  if prev == 0 then
    return 0
  end

  local indent = vim.fn.indent(prev)
  local opens = code(vim.fn.getline(prev)):match("[:%(%[{]$") ~= nil
  if opens then
    indent = indent + vim.fn.shiftwidth()
  end

  -- A line starting with a closing bracket lines up with the line that opened
  -- it, e.g. Enter between "()" gives the ")" its own line at the outer level.
  if vim.fn.getline(lnum):match("^%s*[%)%]}]") then
    indent = opens and indent - vim.fn.shiftwidth() or indent
  end

  return math.max(indent, 0)
end

return M
