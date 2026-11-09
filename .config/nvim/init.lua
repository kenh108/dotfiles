vim.g.mapleader = " "

vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
vim.keymap.set('n', '<Leader><CR>', ':nohlsearch<CR>')

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = ""

-- Tree-sitter handles indent
-- vim.cmd("filetype indent off")

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:append("ro")
    end,
})

local function set_indent(width, filetypes)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        callback = function()
            vim.bo.tabstop     = width
            vim.bo.shiftwidth  = width
            vim.bo.softtabstop = width
        end,
    })
end
set_indent(2, { "yaml", "json", "conf", "toml" })

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
            require('github-theme').setup({
                options = { transparent = true },
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
}

local opts = {
    install = { colorscheme = { "github_dark_default" } },
    checker = { enabled = true },
    change_detection = { enabled = false },
}

require("lazy").setup(plugins, opts)
