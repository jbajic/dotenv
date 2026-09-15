local ts = require("nvim-treesitter")

local ensure_installed = {
  "c", "cpp", "lua", "vim", "vimdoc", "query",
  "rust", "python", "javascript", "markdown", "markdown_inline",
}

ts.setup {}
ts.install(ensure_installed)

local function is_installed(lang)
  return vim.tbl_contains(ts.get_installed("parsers"), lang)
end

local function start_treesitter(buf)
  vim.treesitter.start(buf)
  vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("jbajic_treesitter", { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if not lang or not vim.tbl_contains(ts.get_available(), lang) then
      return
    end
    if is_installed(lang) then
      start_treesitter(ev.buf)
      return
    end
    ts.install(lang):await(function()
      if vim.api.nvim_buf_is_valid(ev.buf) and is_installed(lang) then
        start_treesitter(ev.buf)
      end
    end)
  end,
})
