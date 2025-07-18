vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.filetype.add {
  extension = {
    ftl = "html",
  },
}
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Auto select virtualenv Nvim open",
  pattern = "*",
  callback = function()
    local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
    if venv ~= "" then require("venv-selector").retrieve_from_cache() end
  end,
  once = true,
})
