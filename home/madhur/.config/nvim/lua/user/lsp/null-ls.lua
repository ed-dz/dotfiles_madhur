local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = true,
	sources = {
--		formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
		formatting.black.with({ extra_args = { "--fast" } }),
        require("none-ls.diagnostics.eslint_d"),
--        null_ls.builtins.code_actions.eslint_d,

  --       null_ls.builtins.diagnostics.eslint_d,
--         null_ls.builtins.formatting.eslint_d,
		formatting.stylua,
--		diagnostics.flake8,
--		null_ls.builtins.code_actions.shellcheck,
--		diagnostics.shellcheck,
		formatting.black,
--		formatting.isort,
		formatting.prettierd,
		formatting.shfmt,
		formatting.stylua,
--		null_ls.builtins.hover.dictionary,
		diagnostics.yamllint.with({ extra_args = { "-c/home/madhur/.config/yamllint/config.yaml" } }),
	},
})
