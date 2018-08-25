local App = function(appConfig, printer, altPrinter, writer, message)
    return
    {
        run = function()
            printer.write("Hello World")
            altPrinter:write("Alternate Hello World")
            writer(message)

            print(appConfig.logPath)

            appConfig.counter = appConfig.counter + 1

            print(appConfig.counter)
        end
    }
end

return App
