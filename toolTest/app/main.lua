local app = require("app.server")
app:run()


-- local lor = require("lor.index")
-- local app = lor()

-- app:conf("view enable", true)
-- app:conf("view engine", "tmpl")
-- app:conf("view ext", "html")
-- app:conf("view layout", "")
-- app:conf("views","./app/views")

-- app:get("/", function(req, res, next)
--     local data = {
--             name =  req.query.name or "lor",
--             id = req.query.id or "100",
--             desc =  req.query.desc or "hello world"
--     }
--     res:render("welcome",data)
-- end)
-- app:run()