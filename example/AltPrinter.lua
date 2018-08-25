local AltPrinter = function()
    local write = function(...)
        print(...)
    end

    return 
    {
        write = write
    }
end

return AltPrinter