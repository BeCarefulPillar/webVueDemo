local lor = require("lor.index")
local homeRouter = lor:Router() -- 生成一个group router对象

homeRouter:get("/PVP_grade", function(req, res, next)
    res:render("PVP_grade")
end)

homeRouter:get("/PVP_rank", function(req, res, next)
    res:render("PVP_grade")
end)


return homeRouter
