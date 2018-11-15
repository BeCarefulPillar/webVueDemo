-- Copyright (C) 2016 Joywinds Inc.

local json = require("cjson")

local M = {}

M.decode = json.decode
M.encode = json.encode

function M.decode_safe(v)
	json.encode_sparse_array(true)
	local ok, ret = pcall(json.decode, v)
	if not ok then
		return nil, ret
	end
	return ret
end

function M.encode_safe(v)
	json.encode_sparse_array(true)
	local ok, ret = pcall(json.encode, v)
	if not ok then
		return nil, ret
	end
	return ret
end

return M