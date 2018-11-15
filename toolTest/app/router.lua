-- 业务路由管理
local playInfo = {
{ id  = 1, name  = " aa "},
{ id  =2, name  = " nnn "},
{ id  = 3, name  = " ccc "},
}




return function(app)

    app:get("/select", function(req, res, next)
     res:json(playInfo)
    end)
    -- app:get("/select", function (req, res, next)
    --     res:json({id = 22,
    --         msg="2222222"})
    --     end)

    app:get("/", function(req, res, next)
        --res:render("index")
        res:json({id = 11,
            msg="11111"})
    end)
    
end

