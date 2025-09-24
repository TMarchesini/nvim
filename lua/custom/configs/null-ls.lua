local null_ls = require('null-ls')

local ops = {
sources = {
	null_ls.builtins.diagnostics.mypy,
	},
}
return opts
