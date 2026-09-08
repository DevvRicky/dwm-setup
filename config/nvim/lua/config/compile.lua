local compile = require("compile-mode")

local M = {}

local java_home = "/usr/lib/jvm/openjdk21"

local function read_file_first_line_or_all(path)
	local f = io.open(path, "r")
	if not f then
		return nil
	end
	local content = f:read("*a")
	f:close()
	return content
end

-- Detect if the current directory (or any parent up to 3 levels up) has a
-- package.json. Returns the directory path or nil.
local function has_package_json()
	local dirs = vim.split(vim.fn.getcwd(), "/", { trimempty = true })
	for i = #dirs, math.max(1, #dirs - 3), -1 do
		local path = table.concat(vim.list_slice(dirs, 1, i), "/")
		if vim.fn.filereadable(path .. "/package.json") == 1 then
			return path
		end
	end
	return nil
end

-- Find the right JS package manager for the project (pnpm/yarn/bun/npm).
local function pkg_runner()
	local dir = has_package_json()
	if not dir then
		return "npm"
	end
	if vim.fn.filereadable(dir .. "/pnpm-lock.yaml") == 1 then
		return "pnpm"
	end
	if vim.fn.filereadable(dir .. "/yarn.lock") == 1 then
		return "yarn"
	end
	if vim.fn.filereadable(dir .. "/bun.lockb") == 1 or vim.fn.filereadable(dir .. "/bun.lock") == 1 then
		return "bun"
	end
	return "npm"
end

-- Is the current project a React Native project?
local function is_react_native()
	local dir = has_package_json()
	if not dir then
		return false
	end
	local content = read_file_first_line_or_all(dir .. "/package.json")
	return content ~= nil and content:find("react%-native") ~= nil
end

M.default_command = function()
	local buf_dir = vim.fn.expand("%:p:h")

	-- 1) A per-project `.compile` script in the buffer's directory wins.
	if vim.fn.filereadable(buf_dir .. "/.compile") == 1 then
		return "sh " .. buf_dir .. "/.compile"
	end
	if vim.fn.filereadable(".compile") == 1 then
		return "sh .compile"
	end

	local ft = vim.bo.filetype

	-- 2) React Native
	if is_react_native() then
		local name = string.lower(vim.fn.expand("%:t"))
		if name == "app.json" or ft == "javascriptreact" or ft == "typescriptreact" or ft == "jsx" or ft == "tsx" then
			return pkg_runner() .. " run android"
		end
	end

	-- 3) Per-filetype fallbacks
	local cmds = {
		c = "gcc -Wall -Wextra -o %:r % && ./%:r",
		cpp = "g++ -Wall -Wextra -std=c++17 -o %:r % && ./%:r",
		python = "python3 %",
		rust = "rustc % -o %:r && ./%:r",
		go = "go run %",
		java = java_home .. "/bin/javac % && " .. java_home .. "/bin/java %:r",
		javascript = "node %",
		javascriptreact = "node %",
		typescript = "npx ts-node %",
		typescriptreact = "npm run build",
		lua = "lua %",
		sh = "sh %",
		bash = "bash %",
		astro = "npm run build",
		html = "xdg-open %",
		css = "echo \"nothing to compile for CSS\"",
		sql = "echo \"no single-file runner; use sqlite3 interactively\"",
	}

	return cmds[ft] or ""
end

vim.g.compile_mode = {
	default_command = M.default_command,

	baleia_setup = true,
	bang_expansion = false,

	error_threshold = compile.level.WARNING,
	auto_jump_to_first_error = true,
	error_locus_highlight = 500,

	ask_about_save = true,
	ask_to_interrupt = true,

	recompile_no_fail = true,

	focus_compilation_buffer = true,
	auto_scroll = true,
	hidden_buffer = false,

	use_diagnostics = false,
	use_pseudo_terminal = true,

	use_circular_error_navigation = true,

	debug = false,
}

-- shortcuts
vim.keymap.set("n", "<F5>", "<Cmd>Compile<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<F6>", "<Cmd>Recompile<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "]e", "<Cmd>NextError<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "[e", "<Cmd>PrevError<CR>", { noremap = true, silent = true })
