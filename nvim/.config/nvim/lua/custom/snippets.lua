-- my_snippets.lua file

local M = {}

local global_snippets = {
	{ trigger = "shebang", body = "#!/bin sh" },
}

local snippets_by_filetype = {
	lua = {
		{ trigger = "fun", body = "function ${1:name}(${2:args}) $0 end" },
	},
	javascriptreact = {
		-- Console Log
		{ trigger = "cons", body = "console.log(${1:log}) $0" },

		-- React Functional Component
		{
			trigger = "rfc",
			body = "const ${1:ComponentName}: React.FC = () => {\n  return (\n    <div>\n      ${2:content}\n    </div>\n  );\n};\n$0",
		},

		-- React useState Hook
		{ trigger = "us", body = "const [${1:state}, set${2:State}] = useState<${3:type}>(${4:initialValue});$0" },

		-- React useEffect Hook
		{
			trigger = "ue",
			body = "useEffect(() => {\n  ${1:effect}\n  return () => {\n    ${2:cleanup}\n  };\n}, [${3:dependencies}]);$0",
		},

		-- TypeScript Interface
		{ trigger = "intf", body = "interface ${1:InterfaceName} {\n  ${2:property}: ${3:type};\n}$0" },

		-- TypeScript Type Alias
		{ trigger = "type", body = "type ${1:TypeName} = {\n  ${2:property}: ${3:type};\n};$0" },

		-- React useCallback Hook
		{
			trigger = "ucb",
			body = "const ${1:callback} = useCallback(() => {\n  ${2:code}\n}, [${3:dependencies}]);$0",
		},

		-- React useMemo Hook
		{
			trigger = "um",
			body = "const ${1:memoizedValue} = useMemo(() => {\n  return ${2:value};\n}, [${3:dependencies}]);$0",
		},

		-- React useRef Hook
		{ trigger = "urf", body = "const ${1:ref} = useRef<${2:type}>(${3:initialValue});$0" },

		-- TypeScript Enum
		{ trigger = "enum", body = 'enum ${1:EnumName} {\n  ${2:KEY} = "${3:value}",\n}$0' },

		-- React Props with TypeScript
		{
			trigger = "props",
			body = "interface ${1:Props} {\n  ${2:propName}: ${3:type};\n}\n\nconst ${4:Component}: React.FC<${1:Props}> = ({ ${2:propName} }) => {\n  return <div>{${2:propName}}</div>;\n};$0",
		},

		-- React useContext Hook
		{ trigger = "uctx", body = "const ${1:context} = useContext(${2:Context});$0" },

		-- React Fragment
		{ trigger = "rfrag", body = "<React.Fragment>\n  ${1:children}\n</React.Fragment>$0" },

		-- React useReducer Hook
		{ trigger = "ur", body = "const [${1:state}, ${2:dispatch}] = useReducer(${3:reducer}, ${4:initialState});$0" },

		-- Custom Event Handler
		{
			trigger = "onchange",
			body = "const handleChange = (event: React.ChangeEvent<${1:HTMLInputElement}>) => {\n  ${2:logic}\n};$0",
		},
	},
	typescriptreact = {
		-- Console Log
		{ trigger = "cons", body = "console.log(${1:log}) $0" },

		-- React Functional Component
		{
			trigger = "rfc",
			body = "const ${1:ComponentName}: React.FC = () => {\n  return (\n    <div>\n      ${2:content}\n    </div>\n  );\n};\n$0",
		},

		-- React useState Hook
		{ trigger = "us", body = "const [${1:state}, set${2:State}] = useState<${3:type}>(${4:initialValue});$0" },

		-- React useEffect Hook
		{
			trigger = "ue",
			body = "useEffect(() => {\n  ${1:effect}\n  return () => {\n    ${2:cleanup}\n  };\n}, [${3:dependencies}]);$0",
		},

		-- TypeScript Interface
		{ trigger = "intf", body = "interface ${1:InterfaceName} {\n  ${2:property}: ${3:type};\n}$0" },

		-- TypeScript Type Alias
		{ trigger = "type", body = "type ${1:TypeName} = {\n  ${2:property}: ${3:type};\n};$0" },

		-- React useCallback Hook
		{
			trigger = "ucb",
			body = "const ${1:callback} = useCallback(() => {\n  ${2:code}\n}, [${3:dependencies}]);$0",
		},

		-- React useMemo Hook
		{
			trigger = "um",
			body = "const ${1:memoizedValue} = useMemo(() => {\n  return ${2:value};\n}, [${3:dependencies}]);$0",
		},

		-- React useRef Hook
		{ trigger = "urf", body = "const ${1:ref} = useRef<${2:type}>(${3:initialValue});$0" },

		-- TypeScript Enum
		{ trigger = "enum", body = 'enum ${1:EnumName} {\n  ${2:KEY} = "${3:value}",\n}$0' },

		-- React Props with TypeScript
		{
			trigger = "props",
			body = "interface ${1:Props} {\n  ${2:propName}: ${3:type};\n}\n\nconst ${4:Component}: React.FC<${1:Props}> = ({ ${2:propName} }) => {\n  return <div>{${2:propName}}</div>;\n};$0",
		},

		-- React useContext Hook
		{ trigger = "uctx", body = "const ${1:context} = useContext(${2:Context});$0" },

		-- React Fragment
		{ trigger = "rfrag", body = "<React.Fragment>\n  ${1:children}\n</React.Fragment>$0" },

		-- React useReducer Hook
		{ trigger = "ur", body = "const [${1:state}, ${2:dispatch}] = useReducer(${3:reducer}, ${4:initialState});$0" },

		-- Custom Event Handler
		{
			trigger = "onchange",
			body = "const handleChange = (event: React.ChangeEvent<${1:HTMLInputElement}>) => {\n  ${2:logic}\n};$0",
		},
	},
}

-- my_snippets.lua file

local function get_buf_snips()
	local ft = vim.bo.filetype
	local snips = vim.list_slice(global_snippets)

	if ft and snippets_by_filetype[ft] then
		vim.list_extend(snips, snippets_by_filetype[ft])
	end

	return snips
end

-- cmp source for snippets to show up in completion menu
function M.register_cmp_source()
	local cmp_source = {}
	local cache = {}
	function cmp_source.complete(_, _, callback)
		local bufnr = vim.api.nvim_get_current_buf()
		if not cache[bufnr] then
			local completion_items = vim.tbl_map(function(s)
				---@type lsp.CompletionItem
				local item = {
					word = s.trigger,
					label = s.trigger,
					kind = vim.lsp.protocol.CompletionItemKind.Snippet,
					insertText = s.body,
					insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
				}
				return item
			end, get_buf_snips())

			cache[bufnr] = completion_items
		end

		callback(cache[bufnr])
	end

	require("cmp").register_source("snp", cmp_source)
end

return M
