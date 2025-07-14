-- bootstrap lazy.nvim if it's not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Shortcut to make keymaps easier
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Use system clipboard as default
vim.opt.clipboard = "unnamedplus"

-- ~/.config/nvim/init.lua

vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "morhetz/gruvbox" },
  { "stevearc/oil.nvim", opts = {}, keys = { { "-", "<CMD>Oil<CR>", desc = "Open parent directory" } } },
  { "folke/which-key.nvim", config = true },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  { "lewis6991/gitsigns.nvim", config = true },
  { "echasnovski/mini.surround", version = "*", config = function() require("mini.surround").setup() end },
  { "nvim-lualine/lualine.nvim", config = true },
})

-- Set theme
vim.opt.termguicolors = true
vim.cmd.colorscheme("gruvbox")

require("lualine").setup()
-- KEYMAPS
-- <leader>ff = Telescope file finder
keymap("n", "<leader>ff", function()
  require("telescope.builtin").find_files()
end, opts)

-- Save file
keymap("n", "<leader>w", ":w<CR>", opts)

-- Quit
keymap("n", "<leader>q", ":q<CR>", opts)

-- Save + quit
keymap("n", "<leader>x", ":x<CR>", opts)

-- Clear search highlight
keymap("n", "<leader>c", ":nohlsearch<CR>", opts)

-- Exit insert mode with jk
keymap("i", "jk", "<Esc>", opts)

-- Black hole delete (doesn't yank into register)
keymap("n", "<leader>d", '"_dd', opts)
keymap("v", "<leader>d", '"_d', opts)



