local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

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
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins
  use "kyazdani42/nvim-web-devicons"
  use "kyazdani42/nvim-tree.lua"
  use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter

  -- Colorscheme
  use "folke/tokyonight.nvim"
  use {
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons" }
  }

  -- lsp & cmp plugins
  use {
	  "VonHeikemen/lsp-zero.nvim",
	  branch = "v1.x",
	  requires = {
		  -- LSP Support
		  {"neovim/nvim-lspconfig"},
		  {"williamboman/mason.nvim"},
		  {"williamboman/mason-lspconfig.nvim"},

		  -- Autocompletion
		  {"hrsh7th/nvim-cmp"},
		  {"hrsh7th/cmp-buffer"},
		  {"hrsh7th/cmp-path"},
		  {"saadparwaiz1/cmp_luasnip"},
		  {"hrsh7th/cmp-nvim-lsp"},
		  {"hrsh7th/cmp-nvim-lua"},
	  }
  }

  -- Commenting and Uncommenting plugin
  use("preservim/nerdcommenter")

  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- Telescope
    use {
	  "nvim-telescope/telescope.nvim",
	  requires = {
		  {"nvim-lua/plenary.nvim"},
		  {"nvim-telescope/telescope-live-grep-args.nvim"},
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
  use "lewis6991/gitsigns.nvim"

  -- Tmux navigator
  use "christoomey/vim-tmux-navigator"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

