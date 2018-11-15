local errors = require("app.libs.errors")
local playerserialize = require("app.libs.playerserialize")
local serialize = require("app.libs.serialize")
local mysqlpool = require("app.libs.db.mysqlpool")
local mysql = require("resty.mysql")
local sqlbuilder = require("app.libs.db.sqlbuilder")
local mysqlaux = require("mysqlaux.c")

local escape = mysqlaux.quote_sql_str
local strfmt = string.format

local M = {}

local TAG_CHARS = "AIEJQ9651BX0CDZGPWF7YKOVSMUR2LH3NT84"

local function playerDecode(record)
    return xpcall(playerserialize.decode, debug.traceback, record)
end

function M.getAccount(accountId)
    local db = mysqlpool.getDB(accountId)
    if not db then
        return nil, errors.SERVER_ERROR, "db_error"
    end

    local sql = string.format("SELECT * FROM accounts WHERE accountId=%s", escape(accountId))
    local ret,err = db:query(sql)
    db:close()

    if not ret then
        return nil, errors.SERVER_ERROR, "db_error"
    end

    if #ret == 0 then
        return nil, errors.ACCOUNT_NOT_EXISTS, "account_not_exist"
    end

    return ret[1].playerId
end

function M.getPlayer(playerId)

    local db,area = mysqlpool.getDB(playerId)
    -- print(area)
    if not db then
        return nil, errors.SERVER_ERROR, "db_error"
    end
    local sql = string.format("SELECT * FROM players WHERE id=%s", escape(playerId))
    local ret, err = db:query(sql)
    if err then
        ngx.say("err  ", err)
    end
    db:close()

    if not ret then
        return nil, errors.SERVER_ERROR, "db_error"
    end

    if #ret == 0 then
        return nil, errors.PLAYER_NOT_EXISTS, "player_not_exist"
    end

    local ok, ret = playerDecode(ret[1])

    if not ok then
        return nil, errors.SERVER_ERROR, "db_error"
    end
    
    return ret
end

function M.savePlayer(player, persistant)
    --dataEvents.fire(dataEvents.TYPE.UPDATE_LEADERBOARD,player)
    
    local playerId = player.id
    player = playerserialize.encode(player)
    player.id = nil
    local sql = sqlbuilder.build_updateplayer_sql(player, playerId)
    local db = mysqlpool.getDB(playerId)
    local ret, err = db:query(sql)
    db:close()
end

return M