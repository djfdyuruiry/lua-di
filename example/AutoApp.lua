local AutoApp = {}
AutoApp.__index = AutoApp

function AutoApp.new(appConfig, example__Printer, example__AltPrinter)
    return setmetatable(
    {
        appConfig = appConfig,
        printer = example__Printer,
        altPrinter = example__AltPrinter
    }, AutoApp)
end

function AutoApp.run(self)
    self.printer:write("Goodbye World")

    self.altPrinter.write(self.appConfig.logPath)

    print(self.appConfig.counter)

    self.appConfig.counter = self.appConfig.counter - 2
end

return AutoApp
