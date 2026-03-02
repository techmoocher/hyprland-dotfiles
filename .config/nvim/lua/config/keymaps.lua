local keymap = vim.keymap


-- Jump one paragraph
keymap.set("n", "<C-Down>", "}", { desc = "Move down one paragraph" })
keymap.set("n", "<C-Up>", "{", { desc = "Move up one paragraph" })
keymap.set("i", "<C-Down>", "<C-o>}", { desc = "Move down one paragraph" })
keymap.set("i", "<C-Up>", "<C-o>{", { desc = "Move up one paragraph" })
