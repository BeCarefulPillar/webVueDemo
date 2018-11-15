local mysql = require("app.libs.db.mysql")
local ffi = require("ffi")
local bit = require("bit")

local M = {}

M.AREA_NUM = 32


local function readonly(t)
    local newTable = {}
    local mt = {
        __index=t,
        __newindex=function(t, k, v)
            error("read only!");
        end}
    setmetatable(newTable, mt);
    return newTable
end

local SHARDED_DB = {
    readonly({host="192.168.1.105", port=3306, db="mlShard01", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard02", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard03", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard04", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard05", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard06", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard07", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard08", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard09", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard10", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard11", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard12", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard13", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard14", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard15", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard16", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard17", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard18", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard19", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard20", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard21", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard22", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard23", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard24", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard25", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard26", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard27", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard28", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard29", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard30", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard31", user="mlUser",password="1KlP#6oWOX"}),
    readonly({host="192.168.1.105", port=3306, db="mlShard32", user="mlUser",password="1KlP#6oWOX"}),
}


-- Fowler / Noll / Vo (FNV) Hash
-- http://www.isthe.com/chongo/tech/comp/fnv/
local FNV_32_HASH_START = 216613626;

local function fnv32(key)
    local hash = ffi.new("unsigned long",FNV_32_HASH_START)
    for i = 1, #key do
        hash = hash + bit.lshift(hash, 1) + bit.lshift(hash, 4) + bit.lshift(hash, 7) + 
        bit.lshift(hash, 8) + bit.lshift(hash, 24) 
        hash = bit.bxor(hash, key:byte(i))
    end
    hash = bit.bxor(hash,32)
    return hash
end

function M.getArea(key)
    key = assert(tostring(key))
    return tostring((fnv32(key) % M.AREA_NUM) + 1)
end

function M.getAreaDB(area)
    local shard = SHARDED_DB[area]
    local db, err = mysql.open(shard)
    if not db then
        return nil, err
    end
    return db, area
end

function M.getDB(key)
    local area = M.getArea(key)
    area = tonumber(string.sub(area,1,-4)) 
    --ngx.say("1111111: ",area)
    return M.getAreaDB(area)
end

return M