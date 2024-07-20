GIT_CWD = function()
	return vim.fn.systemlist("git rev-parse --show-toplevel")[1] .. "/"
end
