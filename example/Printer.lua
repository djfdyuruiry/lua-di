local Printer = {}
Printer.__index = Printer

function Printer.new()
    return setmetatable({}, Printer)
end

function Printer.write(self, ...)
    print(...)
end

return Printer