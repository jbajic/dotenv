-- Walks up from the cursor node and shows the enclosing class/function header.
local context_node_types = { class = true, ["function"] = true, method = true }
local function treelocation()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then
    return ""
  end
  local parts = {}
  while node do
    local kind = node:type()
    for pattern in pairs(context_node_types) do
      if kind:find(pattern, 1, true) then
        local row = node:start()
        local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1] or ""
        table.insert(parts, 1, vim.trim(line))
        break
      end
    end
    node = node:parent()
  end
  if #parts == 0 then
    return ""
  end
  local text = table.concat(parts, " -> ")
  if #text > 70 then
    text = text:sub(1, 67) .. "..."
  end
  return " " .. text
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename', treelocation},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
