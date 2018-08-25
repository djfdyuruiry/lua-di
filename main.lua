local DependencyInjectionModule = require "luaDi.DependencyInjectionModule"

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
