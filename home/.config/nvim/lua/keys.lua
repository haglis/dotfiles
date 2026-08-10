-- save by pressing escape
vim.keymap.set('n', '<Esc>', ':w<CR>', { desc = 'Save' })

-- select all
vim.keymap.set('n', '<C-a>', 'ggvG', { desc = 'Select All' })

--pasting over a selection no longer clobbers your clipboard
vim.cmd([[ xnoremap <expr> p 'pgv"'.v:register.'y' ]])
