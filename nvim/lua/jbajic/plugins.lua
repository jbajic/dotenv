local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n" .. out, "ErrorMsg" } }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "nvim-lua/popup.nvim",   -- An implementation of the Popup API from vim in Neovim
  "nvim-lua/plenary.nvim", -- Useful lua functions used by lots of plugins
  "nvim-tree/nvim-web-devicons",
  "nvim-tree/nvim-tree.lua",
  "windwp/nvim-autopairs", -- Autopairs, integrates with both cmp and treesitter

  -- Colorscheme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- lsp & cmp plugins
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "saadparwaiz1/cmp_luasnip",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua",
  "lewis6991/hover.nvim",

  -- Commenting and Uncommenting plugin
  "preservim/nerdcommenter",

  -- snippets
  "L3MON4D3/LuaSnip",             -- snippet engine
  "rafamadriz/friendly-snippets", -- a bunch of snippets to use

  -- Telescope
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end,
  },
  "nvim-telescope/telescope-media-files.nvim",

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
  },

  -- Git control over files
  { "lewis6991/gitsigns.nvim", tag = "v0.6" },

  -- install without yarn or npm
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" },
  },

  -- For symbols view
  -- Previously used 'simrat39/symbols-outline.nvim', then it forked into
  "hedyhli/outline.nvim",

  -- https://github.com/ThePrimeagen/harpoon
  "ThePrimeagen/harpoon",

  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "rmagatti/auto-session",
    opts = {
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    },
  },

  "folke/snacks.nvim",
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
  },

  "jbajic/aql-syntax-vim",
}, {
  ui = { border = "rounded" },
  change_detection = { notify = false },
})
