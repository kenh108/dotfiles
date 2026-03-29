-- Keymaps
vim.g.mapleader = " "

local keymap = vim.keymap
keymap.set("n", "<leader>h", "<C-w>h", { desc = "Switch to left window" })
keymap.set("n", "<leader>j", "<C-w>j", { desc = "Switch to window below" })
keymap.set("n", "<leader>k", "<C-w>k", { desc = "Switch to window above" })
keymap.set("n", "<leader>l", "<C-w>l", { desc = "Switch to right window" })

-- Vim options
vim.opt.autoindent = true
vim.cmd("filetype indent off")

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.bo.softtabstop = 4
vim.opt.expandtab = true

vim.opt.relativenumber = true

vim.opt.mouse = ""

vim.cmd([[
    set whichwrap+=<,h
    set whichwrap+=>,l
    set whichwrap+=[,]")
]])

vim.cmd("autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "yaml",
	callback = function()
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
		vim.bo.expandtab = true
	end,
})

-- Clean copy toggle
local clean_copy = false

local original_neotree_state = nil

function ToggleCleanCopy()
	if not clean_copy then
		local neotree_visible = false
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			local ft = vim.api.nvim_buf_get_option(buf, "filetype")
			if ft == "neo-tree" then
				neotree_visible = true
				break
			end
		end
		original_neotree_state = neotree_visible

		vim.wo.relativenumber = false
		if original_neotree_state then
			vim.cmd("Neotree close")
		end
		clean_copy = true
	else
		vim.wo.relativenumber = true
		if original_neotree_state then
			vim.cmd("Neotree show")
		end

		clean_copy = false
	end
end

vim.keymap.set(
	"n",
	"<leader>cc",
	ToggleCleanCopy,
	{ desc = "Toggle clean copy mode (no line numbers, close NeoTree if open)" }
)

-- Lazy setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        opts = {
            variant = "dawn",
        },
        config = function(_, opts)
            require("rose-pine").setup(opts)
            vim.cmd("colorscheme rose-pine")
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup()
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons", -- optional, but recommended
        },
        lazy = false, -- neo-tree will lazily load itself
        config = function()
            local keymap = vim.keymap

            keymap.set("n", "<leader>e", "<cmd>Neotree filesystem toggle left<CR>", {})
        end,
    },
}

local opts = {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		enabled = false,
		notify = true,
	},
}

require("lazy").setup(plugins, opts)
