-- Copyright (C) 2016 Joywinds Inc.

-- memdata stores all global in memory data, it is the only place
-- to store data.

local memdata = {}

memdata.connection_address = {}
memdata.players = {}
memdata.player_conns = {}
memdata.pending_tcp = {}
memdata.mysql_conn = {}
memdata.redis_conn = {}
memdata.timer_callbacks = {}

return memdata
