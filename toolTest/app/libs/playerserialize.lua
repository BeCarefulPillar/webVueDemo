
local utils = require("Common.Utils")
local pairs = pairs
local type = type
local strfmt = string.format
local osdate = os.date
local ostime = os.time
local serialize = require("app.libs.serialize")

local M = {}

local function unixtime_from_string(s, fmt)
	if not fmt then
		fmt = "(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)"
	end
	local year, month, day, hour, min, sec = s:match(fmt)
	return ostime{year=year,month=month,day=day,hour=hour,min=min,sec=sec}
end

local function encode_string(v)
	if not v then return v end
	--assert(type(v) == "string")
	return v
end

local function encode_int(v)
	if not v then return v end
	--assert(type(v) == "number")
	return tonumber(v)
end

local function encode_datetime(v)
	if not v then return v end
	--assert(type(v) == "number")
	return utils.unixtime_to_string(v)
end

local function encode_object(v, key)
	if not v then return v end
	--assert(type(v) == "table")
	if key then
		local t = {}
		for _, ele in pairs(v) do
			t[#t + 1] = ele
		end
		v = t
	end
	v = assert(serialize.encode_safe(v))
	return v
end

local function decode_string(v)
	if v == nil or v == g_NULL then return nil end
	--assert(type(v) == "string")
	return v
end

local function decode_int(v)
	if not v then return v end
	--assert(type(v) == "number")
	return tonumber(v)
end

local function decode_object(v, key)
	if v == nil or v == g_NULL or v == "" then return nil end
	--assert(type(v) == "string")
	v = assert(serialize.decode_safe(v))
	if key then
		local t = {}
		for _, ele in pairs(v) do
			t[ele[key]] = ele
		end
		return t
	end
	return v
end


local function decode_datetime(v)
	if not v then return v end
	--assert(type(v) == "string")
	return unixtime_from_string(v)
end


function M.encode(player)
	local t = {}
	t.id = encode_int(player.id)
	t.name = encode_string(player.name)
	t.sex = encode_int(player.sex)
	t.level = encode_int(player.level)
	t.exp = encode_int(player.exp)
	t.gold = encode_int(player.gold)
	t.gem = encode_int(player.gem)
	t.gemStone = encode_int(player.gemStone)
	t.recruit = encode_int(player.recruit)
	t.vipLevel = encode_int(player.vipLevel)
	t.vipExp = encode_int(player.vipExp)
	t.head = encode_int(player.head)
	t.frame = encode_int(player.frame)
	t.body = encode_object(player.body)
	t.loginAt = encode_datetime(player.loginAt)
	t.updatedAt = encode_datetime(player.updatedAt)
	t.createdAt = encode_datetime(player.createdAt)
	return t
end

function M.decode(record)
	local player = {}
	player.id = decode_string(record.id)
	player.tag = decode_string(record.tag)
	player.name = decode_string(record.name)
	player.sex = decode_int(record.sex)
	player.level = decode_int(record.level)
	player.exp = decode_int(record.exp)
	player.gold = decode_int(record.gold)
	player.gem = decode_int(record.gem)
	player.gemStone = decode_int(record.gemStone)
	player.recruit = decode_int(record.recruit)
	player.vipLevel = decode_int(record.vipLevel)
	player.vipExp = decode_int(record.vipExp)
	player.head = decode_int(record.head)
	player.frame = decode_int(record.frame)
	player.body = decode_object(record.body)
	player.loginAt = decode_datetime(record.loginAt)
	player.updatedAt = decode_datetime(record.updatedAt)
	player.createdAt = decode_datetime(record.createdAt)

	return player
end

return M