-- typescript-language-server, for projects tsc (TypeScript 7) can't handle.
-- See ts_legacy.lua.
local legacy = require("core.lsp.servers.ts_legacy")
legacy.only_when("ts_ls", legacy.is_legacy)
