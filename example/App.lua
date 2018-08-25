local App = {}
App.__index = App

function App.new(appConfig, printer, altPrinter, writer, message)
    return setmetatable(
    {
        appConfig = appConfig,
        printer = printer,
        altPrinter = altPrinter,
        writer = writer,
        message = message
    }, App)
end

function App.run(self)
    self.printer:write("Hello World")
    self.writer(self.message)

    self.altPrinter.write(self.appConfig.logPath)

    print(self.appConfig.counter)

    self.appConfig.counter = self.appConfig.counter + 1
end

return App
