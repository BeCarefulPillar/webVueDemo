-- Copyright (C) Joywinds Inc.

local mysqlaux = require("mysqlaux.c")
local mysql = require("resty.mysql")
local CONNECT_TIMEOUT_MS = 8000

local M = {}

M.escape = mysqlaux.quote_sql_str

local mt = {__index = M}

local function mysql_gc(obj)
	if obj.__mysql.state then
	    logw("mysql object released by gc")
		obj.__mysql:close()
	end
end

function M.open(params)
	local db, err = mysql:new()
	if not db then  
	   	ngx.say("new mysql error : ", err)  
	    	return  
	end  
	
	local ok, err, errno, sqlstate = db:connect({
		host = params.host,
		port = params.port,
		database = params.db,
	    	user = params.user,
		password = params.password,
		timeout = CONNECT_TIMEOUT_MS,
		max_packet_size = 1024 * 1024,
		})
	if not ok then
		ngx.log(ngx.ERR, err)
	        	db:close()
	        	return
    	end

    	local ret, err = db:query("SET NAMES utf8")
    	if not ret then
    		ngx.log(ngx.ERR, err)
		db:close()
		return
	end
	return db
end

-- function M.query(self, sql, ...)
-- 	local args = {...}
-- 	if #args > 0 then
-- 		sql = string.format(sql, ...)
-- 	end
-- 	local start_time = system.current_time()
-- 	local ret, err, errcode, sqlstate = self.__mysql:query(sql)
-- 	local query_time = system.current_time() - start_time
-- 	if query_time >= 500 then
-- 		--logw("mysql slow query %d ms (%s)", query_time, sql:sub(1, 100))
-- 		local file = io.open("mysql_slow_query.log", "a+")
-- 		if file then
-- 			file:write(string.format("[%s] %d ms (%s)\n", os.date("%Y-%m-%d %H:%M:%S"), query_time, sql:sub(1, 100)))
-- 			file:close()
-- 		end
-- 	end
-- 	if not ret and errcode ~= 1062 then
-- 		self.__output_log(debug.traceback(coroutine.running(), "mysql: "..err))
-- 	end
-- 	return ret, err, errcode, sqlstate
-- end

function M.close(self)
	local co = coroutine.running()
	-- if memdata.mysql_conn[co] then
	-- 	memdata.mysql_conn[co][self] = nil
	-- end
	return self.__mysql:close()
end

function M.startTransaction(self)
	return self:query("BEGIN")
end

function M.commit(self)
	return self:query("COMMIT")
end

function M.rollback(self)
	return self:query("ROLLBACK")
end

function M.send_query(self, query)
	return self.__mysql:send_query(query)
end

function M.read_result(self)
	return self.__mysql:read_result()
end

return M
