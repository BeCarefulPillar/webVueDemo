local pairs = pairs
local ipairs = ipairs
local lor = require("lor.index")
local datastore = require("app.libs.datastore")
local authRouter = lor:Router()
local playInfo = {}

authRouter:get("/select", function(req, res, next)
            --res:render("index")
        res:json({id = 11,
            msg="11111"})
end)

-- authRouter:post("/select", function(req, res, next)
--     local accountName = req.body.accountName
--     local playId = datastore.getAccount(accountName) 
--     if not playId then
--             ngx.say("not find playId not")
--             return
--     end

--     playInfo = datastore.getPlayer(playId)
--     if not playInfo then
--         ngx.say("not find playInfo")
--         return 
--     end
--     playInfo.accountName  = accountName
--     res:render("select", {
--         user = playInfo,
--     })

--     res:json({
--         msg = "select successful"
--     })

-- end)

-- authRouter:post("/save", function(req, res, next)
--     local tempPlayInfo = {}
--     tempPlayInfo.id = req.body.id
--     tempPlayInfo.tag = req.body.tag
--     tempPlayInfo.name = req.body.name
--     tempPlayInfo.sex = req.body.sex
--     tempPlayInfo.level = req.body.level
--     tempPlayInfo.exp = req.body.exp
--     tempPlayInfo.gold = req.body.gold
--     tempPlayInfo.gem = req.body.gem
--     tempPlayInfo.gemStone = req.body.gemStone
--     tempPlayInfo.recruit  = req.body.recruit
--     tempPlayInfo.vipLevel = req.body.vipLevel
--     tempPlayInfo.vipExp = req.body.vipExp
--     tempPlayInfo.head = req.body.head
--     tempPlayInfo.frame = req.body.frame
--     tempPlayInfo.loginAt = req.body.loginAt
--     tempPlayInfo.updatedAt = req.body.updatedAt
--     tempPlayInfo.createdAt = req.body.createdAt
--     tempPlayInfo.body = playInfo.body

--     datastore.savePlayer(tempPlayInfo)

--     res:render("select", {
--         user = tempPlayInfo,
--     })

--     res:json({
--         msg = "save successful"
--     })
-- end)


-- authRouter:get("/logout", function(req, res, next)
--     req.session.destroy()
--     res:redirect("/auth/login")
-- end)

return authRouter

