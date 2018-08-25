local DependencyInjectionModule = require "lua-di.DependencyInjectionModule"

-- App module example
local appModule = DependencyInjectionModule(function(config)
    config.bindings.types.appConfig = "AppConfig"
    config.bindings.types.printer = "example.Printer"
    config.bindings.types.altPrinter = "example.AltPrinter"

    config.bindings.values.message = "Orders Recieved Captain"

    config.bindings.values.writer = function(...)
        print(...)
    end

    config.providers.AppConfig = function()
        return
        {
            logPath = "/var/log/app.log",
            counter = 5
        }
    end
    config.singletons.AppConfig = true
end)

local app = appModule.getInstance("example.App")

app:run()

app = appModule.getInstance("example.App")

app:run()

-- Auto configuration example
local autoAppModule = DependencyInjectionModule(function(config)
    config.enableAutoConfiguration()

    config.bindings.types.appConfig = "AppConfig"

    config.providers.AppConfig = function()
        return
        {
            logPath = "/var/log/autoApp.log",
            counter = 7
        }
    end
    config.singletons.AppConfig = true
end)


local autoApp = autoAppModule.getInstance("example.AutoApp")

autoApp:run()

autoApp = autoAppModule.getInstance("example.AutoApp")

autoApp:run()
