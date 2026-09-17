-- Keymaps
vim.g.mapleader = " "
vim.keymap.set("n", " ", "<Nop>", { desc = "Ignore space", silent = true })

vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Switch to left window" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Switch to window below" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Switch to window above" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Switch to right window" })

-- Clear search highlights with Space + Enter
vim.keymap.set('n', '<Leader><CR>', ':nohlsearch<CR>', { desc = "Clear search highlights" })

-- Vim options
vim.opt.autoindent = true
vim.cmd("filetype indent off")

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.bo.softtabstop = 4
vim.opt.expandtab = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = ""

vim.cmd("autocmd FileType * setlocal formatoptions+=r formatoptions+=o") 

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "yaml", "json" },
    callback = function()
        vim.bo.tabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
        vim.bo.expandtab = true
    end,
})

-- Make yank automatically copy to local clipboard via OSC 52
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        -- Get the yanked text
        local content = vim.fn.getreg('"')
        if content == "" then
            return
        end

        -- Encode and send OSC 52 sequence
        local encoded = vim.fn.system('base64 -w0', content)
        encoded = encoded:gsub('\n', '')
        io.stdout:write('\x1b]52;c;' .. encoded .. '\x07')
        io.stdout:flush()
    end,
})

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
        'projekt0n/github-nvim-theme',
        name = 'github-theme',
        lazy = false,
        priority = 1000,
        config = function()
            -- local palettes = {
            --     github_dark_dimmed = {
            --         bg1 = '#101216',
            --     },
            -- }
            require('github-theme').setup({
                options = {
                    transparent = true,
                },
                palettes = palettes,
            })
            vim.cmd('colorscheme github_dark_default')
        end,
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
            vim.keymap.set("n", "<leader>e", "<cmd>Neotree filesystem toggle left<CR>", {})

            require("neo-tree").setup({
                filesystem = {
                    filtered_items = {
                        visible = true,
                        never_show = {
                            ".venv",
                            "__pycache__",
                            ".git",
                        },
                    },
                    window = {
                        mappings = {
                            ["/"] = "",
                        },
                    },
                },
                event_handlers = {
                    {
                        event = "neo_tree_buffer_enter",
                        handler = function()
                            vim.opt_local.number = true
                            vim.opt_local.relativenumber = true
                        end,
                    },
                },
            })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter',
        -- branch = 'master',
        lazy = false,
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter').install { 'lua', 'python', 'bash', 'html', 'json' }
            -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            -- this works for files opened with nvim command or afterwards from nvim (eg. :edit ...)
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "*",
                callback = function()
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
            vim.opt.indentkeys = ""
        end
    },
    {
        "kylechui/nvim-surround",
        version = "^4.0.0", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        -- Optional: See `:h nvim-surround.configuration` and `:h nvim-surround.setup` for details
        -- config = function()
        --     require("nvim-surround").setup({
        --         -- Put your configuration here
        --     })
        -- end
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

