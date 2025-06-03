local fn = vim.fn

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don"t error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  use "wbthomason/packer.nvim"
  use "nvim-lua/popup.nvim"   -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins
  use "nvim-tree/nvim-web-devicons"
  use "nvim-tree/nvim-tree.lua"
  use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter

  -- Colorscheme
  --use "folke/tokyonight.nvim"
  use { "catppuccin/nvim", as = "catppuccin" }
  use {
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons" }
  }

  -- lsp & cmp plugins
  use { "neovim/nvim-lspconfig" }
  use { "williamboman/mason.nvim" }
  use { "williamboman/mason-lspconfig.nvim" }
  use { "saadparwaiz1/cmp_luasnip" }
  use { "hrsh7th/nvim-cmp" }
  use { "hrsh7th/cmp-buffer" }
  use { "hrsh7th/cmp-path" }
  use { "hrsh7th/cmp-nvim-lsp" }
  use { "hrsh7th/cmp-nvim-lua" }
  use {"lewis6991/hover.nvim" }

  -- Commenting and Uncommenting plugin
  use("preservim/nerdcommenter")

  -- snippets
  use "L3MON4D3/LuaSnip"             --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- Telescope
  use { "nvim-telescope/telescope-fzf-native.nvim", run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build" }
  use {
    "nvim-telescope/telescope.nvim",
    --tag = "0.1.1",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-live-grep-args.nvim" },
    },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end
  }
  use "nvim-telescope/telescope-media-files.nvim"

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }

  -- Git control over files
  use {
    "lewis6991/gitsigns.nvim",
    tag = "v0.6"
  }

  -- Markdown preview
  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = {
      "markdown" } end, ft = { "markdown" }, })

  -- Integration with tmux
  use { "alexghergh/nvim-tmux-navigation" }

  -- For symbols view
  use 'simrat39/symbols-outline.nvim'

  -- https://github.com/ThePrimeagen/harpoon
  use 'ThePrimeagen/harpoon'

  use({
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    requires = {
        "nvim-lua/plenary.nvim",
    },
})

--[[  -- For Avante]]
  --[[--use 'nvim-treesitter/nvim-treesitter']]
  --[[use 'stevearc/dressing.nvim']]
  --[[--use 'nvim-lua/plenary.nvim']]
  --[[use 'MunifTanjim/nui.nvim']]
  --[[use 'MeanderingProgrammer/render-markdown.nvim']]

  --[[-- Optional dependencies]]
  --[[--use 'hrsh7th/nvim-cmp']]
  --[[--use 'nvim-tree/nvim-web-devicons' -- or use 'echasnovski/mini.icons']]
  --[[use 'HakonHarnes/img-clip.nvim']]
  --[[use 'zbirenbaum/copilot.lua']]

  --[[-- Avante.nvim with build process]]
  --[[use {]]
    --[['yetone/avante.nvim',]]
    --[[branch = 'main',]]
    --[[run = 'make',]]
    --[[config = function()]]
      --[[require('avante').setup()]]
    --[[end]]
  --[[}]]

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
