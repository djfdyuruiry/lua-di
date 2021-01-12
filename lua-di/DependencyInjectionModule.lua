local unpack = unpack or table.unpack

local DependencyInjectionModule = function(configure)
    local self = {}

    local initalised = false
    local autoInjectEnabled = false
    local providers = {}
    local singletons = {}
    local bindings = 
    {
        types = {},
        values = {}
    }

    local getFunctionArguments = function(subjectFunction)
        local functionArguments = {}
        local currentHook, mask, count = debug.gethook()
        
        local argumentInspectorHook = function(...)
            local caller = debug.getinfo(3)

            if "pcall" ~= caller.name then 
                return
            end
        
            for i = 1, math.huge do
                local name, _ = debug.getlocal(2, i)
        
                if "(*temporary)" == name then
                    -- reset debug hook and error before function starts
                    debug.sethook(currentHook, mask, count)
                    error('')
                    return
                end
        
                table.insert(functionArguments, name)
            end
        end
        
        debug.sethook(argumentInspectorHook, "c")
        pcall(subjectFunction)
        
        return functionArguments
    end

    local getArgumentValue = function(argumentName)
        local bindingType = bindings.types[argumentName]
        local bindingValue = bindings.values[argumentName]

        if type(bindingType) == "string" then
            return self.getInstance(bindingType)
        elseif bindingValue ~= nil then
            return bindingValue
        end

        if autoInjectEnabled then
            local moduleName = argumentName:gsub("__", ".")

            return self.getInstance(moduleName)
        end

        return nil
    end

    local buildInstance = function(constructor)
        local constructorArguments = getFunctionArguments(constructor)

        for idx, argumentName in ipairs(constructorArguments) do
            constructorArguments[idx] = getArgumentValue(argumentName)
        end

        return constructor(unpack(constructorArguments))
    end

    local getConstructor = function(moduleName, moduleHandle)
        local moduleHandleType = type(moduleHandle)

        if moduleHandleType == "function" then
            return moduleHandle
        end
    
        if moduleHandleType ~= "table" then
            error(("Unable to determine constructor for module '%s', " ..
                "module return type: %s"):format(moduleName, moduleHandleType))
        end

        local moduleHandleMetatable = getmetatable(moduleHandle)

        if moduleHandleMetatable then
            if type(moduleHandleMetatable.__constructor) == "function" then
                return moduleHandleMetatable.__constructor
            end

            if type(moduleHandleMetatable.__new) == "function" then
                return moduleHandleMetatable.__new
            end
        end

        if type(moduleHandle.new) == "function" then
            return moduleHandle.new
        end

        error(("No constructor function found in table returned by module '%s'. " ..
            "Declare a 'new' function in the module table or '__constructor'/'__new' " ..
            "function in the module metatable"):format(moduleName))
    end

    local dynamicRequire = function(moduleName)
        local moduleHandle
        local moduleLoaded, loadErr = xpcall(function()
            moduleHandle = require(moduleName)
        end, debug.traceback)

        if not moduleLoaded or loadErr then
            error(("Unable to dynamically require module '%s': %s"):format(moduleName, loadErr or "unknown error occurred"))
        end

        return moduleHandle
    end

    local initalise = function()
        if initalised then
            return
        end

        if type(configure) == "function" then
            configure(
                {
                    bindings = bindings,
                    providers = providers,
                    singletons = singletons,
                    enableAutoConfiguration = function()
                        autoInjectEnabled = true
                    end
                }
            )
        end

        for name, _ in pairs(singletons) do
            singletons[name] = {}
        end

        initalised = true
    end
    
    self.getInstance = function(moduleName, ...)
        initalise()

        local instance

        if type(singletons[moduleName]) == "table" and singletons[moduleName].instance ~= nil then
            -- singleton instance
            return singletons[moduleName].instance
        end

        if type(providers[moduleName]) == "function" then
            -- provider function
            instance = providers[moduleName]()
        elseif type(providers[moduleName]) ~= "nil" then
            -- provider instance
            instance = providers[moduleName] 
        end

        if singletons[moduleName] then
            -- initialise singleton instance if needed
            singletons[moduleName].instance = instance

            -- singleton instance
            return singletons[moduleName].instance
        end

        local moduleHandle = dynamicRequire(moduleName)
        local moduleConstructor = getConstructor(moduleName, moduleHandle)

        -- new instance
        return buildInstance(moduleConstructor)
    end

    return self
end

return DependencyInjectionModule
