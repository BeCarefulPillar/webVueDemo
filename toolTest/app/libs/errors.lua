--reloadable

local errorCode = require("libs.ErrorCode")

function RaiseError(errcode, errmsg)
    if not errmsg and type(errcode) == "table" then
        return {error=errcode}
    end
    return {error={code=errcode, msg=errmsg}}
end

return errorCode
