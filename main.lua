local DependencyInjectionModule = require "DependencyInjectionModule"

local appModule = DependencyInjectionModule(function(config)
    config.providers.AppConfig = function()
        return
        {
            logPath = "/var/log/app.log",
            counter = 5
        }
    end
    config.singletons.AppConfig = true

    config.bindings.types.appConfig = "AppConfig"
    config.bindings.types.printer = "example.Printer"
    config.bindings.types.altPrinter = "example.AltPrinter"

    config.bindings.values.writer = function(...)
        print(...)
    end

    config.bindings.values.message = "Orders Recieved Captain"
end)

local app = appModule.getInstance("example.App")

app.run()

app = appModule.getInstance("example.App")

app.run()
