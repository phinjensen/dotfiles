-- Make gl and gh change tabs
lvim.keys.normal_mode["gh"] = ":tabp<CR>"
lvim.keys.normal_mode["gl"] = ":tabn<CR>"
lvim.lsp.buffer_mappings.normal_mode["gy"] = lvim.lsp.buffer_mappings.normal_mode["gl"]
lvim.lsp.buffer_mappings.normal_mode["gl"] = nil --{ function()  end, "blah" }

lvim.plugins = {
    -- much better than telescope, at least how LunarVim configures it
    { "junegunn/fzf" },
    { "junegunn/fzf.vim" },
    -- seoul256, the only good colorscheme
    { "junegunn/seoul256.vim" },
    -- A treesitter version?
    -- { "shaunsingh/seoul256.nvim" }
    { "mfussenegger/nvim-jdtls" }
}

-- Enable seoul256 with a darker background
vim.g.seoul256_background = 233
lvim.colorscheme = "seoul256"
vim.g.seoul256_italic_comments = true
vim.g.seoul256_italic_keywords = false
vim.g.seoul256_italic_functions = false
vim.g.seoul256_italic_variables = false
vim.g.seoul256_contrast = false
vim.g.seoul256_borders = false
vim.g.seoul256_disable_background = true
vim.g.seoul256_hl_current_line = true

-- Remap the annoying SQL omnicomplete key
vim.g.ftplugin_sql_omni_key = '<C-S>'

-- Disable some annoying plugins
lvim.builtin.alpha.active = false           -- starting page
lvim.builtin.autopairs.active = false       -- automatic bracket pairs
lvim.builtin.illuminate.active = false      -- highlighting other instances of word under cursor
lvim.builtin.lir.active = false             -- another file explorer? just use nvim-tree, I guess
lvim.builtin.bufferline.active = false      -- bufferline which makes tabs more complicated

lvim.format_on_save.enabled = true          -- Enable formatting on save
lvim.builtin.nvimtree.setup.view.width = 40 -- Make file browser tree wider

vim.g.fzf_action = {
    enter = "vsplit",
    ["ctrl-t"] = "tab split",
    ["ctrl-s"] = "split",
    ["ctrl-v"] = "vsplit",
    ["ctrl-r"] = "edit"
}
vim.keymap.set("", "<C-l>", ":Files<cr>")

lvim.builtin.project.patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "Cargo.toml" }


vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jdtls" })

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    { name = "prettier", },
}

vim.o.mouse = ""
