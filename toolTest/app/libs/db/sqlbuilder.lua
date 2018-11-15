-- Copyright (C) Joywinds.

local mysqlaux = require("mysqlaux.c")
local serialize = require("app.libs.serialize")
local utils = require("Common.Utils")
local escape = mysqlaux.quote_sql_str
local strfmt = string.format
local tinsert = table.insert
local tremove = table.remove
local tconcat = table.concat
local pairs = pairs
local type = type
local tostring = tostring

local M = {}

function M.build_insertplayer_sql(player, table_name)
	local table_name = table_name or "players"
	local sql_str = {strfmt("INSERT INTO %s (", table_name)}
	for k, v in pairs(player) do
		tinsert(sql_str, k)
		tinsert(sql_str, ",")
	end
	tremove(sql_str)
	tinsert(sql_str, ") VALUES (")
	for k, v in pairs(player) do
		local tp = type(v)
		if tp == "string" then
			tinsert(sql_str, escape(v))
		elseif tp == "number" then
			tinsert(sql_str, tostring(v))
		end
		tinsert(sql_str, ",")
	end
	tremove(sql_str)
	tinsert(sql_str, ")")
	return tconcat(sql_str)
end

function M.build_updateplayer_sql(player, player_id, table_name)
	local table_name = table_name or "players"
	local sql_str = {strfmt("UPDATE %s SET ", table_name)}
	for k, v in pairs(player) do
		tinsert(sql_str, k)
		tinsert(sql_str, "=")
		local tp = type(v)
		if tp == "string" then
			tinsert(sql_str, escape(v))
		elseif tp == "number" then
			tinsert(sql_str, tostring(v))
		end
		tinsert(sql_str, ",")
	end
	tremove(sql_str)
	tinsert(sql_str, strfmt(" WHERE id=%s", tostring(player_id)))
	return tconcat(sql_str)
end

function M.build_createaccount_sql(account_id, player_id)
	return strfmt("INSERT INTO accounts (accountId,playerId) VALUES (%s,%s)", escape(account_id), tostring(player_id))
end

function M.build_settag_sql(player_id, tag)
	return strfmt("UPDATE players SET tag=%s WHERE id=%s", escape(tag), tostring(player_id))
end

local function getPlayerMailSqlHeader(mail_type)
    if mail_type == 1 then
        return "INSERT INTO player_mails(subject,body,sender,attachments,sendTime,expireTime,playerId,type,transactionId) VALUES"
    else
        return "INSERT INTO player_mails(subject,body,sender,attachments,sendTime,expireTime,playerId,type) VALUES"
    end
end

local function getPlayerMailSqlValue(player_id, subject, body, sender, attachments, send_time, expire_time, mail_type, trans_id)
    if mail_type == 1 then
        return strfmt("(%s,%s,%s,%s,%s,%s,%d,%d,%s)",
            subject,body,sender,attachments,send_time,expire_time,player_id,mail_type,trans_id)
    else
        return strfmt("(%s,%s,%s,%s,%s,%s,%d,%d)",
            subject,body,sender,attachments,send_time,expire_time,player_id,mail_type)
    end
end

function M.buildSendPlayerMailSql(playerId, subject, body, sender, attachments, send_time, expire_time, mail_type, trans_id)
    mail_type = mail_type or 0
    if type(send_time) ~= "string" then
        send_time = utils.unixtime_to_string(send_time)
    end
    if type(expire_time) ~= "string" then
        expire_time = utils.unixtime_to_string(expire_time)
    end
    if type(attachments) ~= "string" then
        attachments = serialize.encode(attachments)
    end
    local header = getPlayerMailSqlHeader(mail_type)
    local values = getPlayerMailSqlValue(
        playerId,
        escape(subject),
        escape(body),
        escape(sender),
        escape(attachments),
        escape(send_time),
        escape(expire_time),
        mail_type,
        trans_id and escape(trans_id) or nil)
    return header .. values
end

return M