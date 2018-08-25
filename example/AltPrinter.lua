local AltPrinter = {}
AltPrinter.__index = AltPrinter

function AltPrinter.new()
    return setmetatable({}, AltPrinter)
end

function AltPrinter.write(self, ...)
    print(...)
end

return AltPrinter
