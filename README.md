# lua-di
Dependency injection library for Lua that supports constructor based injection.

- Map constructor parameter names to Lua packages and constant values
- Configure providers to dynamically build parameter types
- Support for configuring types to be kept in singleton scope
- Zero configuration/customisation of application required, exept for main module configuration itself.

----

## Install

Get this library using [luarocks](https://github.com/luarocks/luarocks/wiki/Download): 

----

## Example

Given you have the following classes:

```lua
-- example/Printer.lua
local Printer = {}
Printer.__index = Printer

function Printer.new()
    return setmetatable({}, Printer)
end

function Printer.write(self, ...)
    print(...)
end

return Printer
```

```lua
-- example/App.lua
local App = {}
App.__index = App

function App.new(appConfig, printer, writer, message)
    return setmetatable(
    {
        appConfig = appConfig,
        printer = printer,
        writer = writer,
        message = message
    }, App)
end

function App.run(self)
    self.printer:write("Hello World")
    self.writer(self.message)

    print(self.appConfig.logPath)
end

return App
```

You can configure all your dependencies in one function, then build your application:

```lua
local DependencyInjectionModule = require "luaDi.DependencyInjectionModule"

-- build and configure your app module
local appModule = DependencyInjectionModule(function(config)
    -- bind constructor parameter names to Lua modules
    config.bindings.types.printer = "example.Printer"

    -- bind constructor parameter to constant value
    config.bindings.values.message = "Orders Recieved Captain"

    -- parameter values can be of any type
    config.bindings.values.writer = function(...)
        print(...)
    end
  
    -- bind constructor parameter name to custom type (not a Lua module)
    config.bindings.types.appConfig = "AppConfig"
  
    -- define a provider for your custom type (either a builder function or a constant)
    -- (you can also provide instances for a Lua Package name in config.providers if you wish)
    config.providers.AppConfig = function()
        return
        {
            logPath = "/var/log/app.log",
            counter = 5
        }
    end
    
    -- make injected AppConfig instance a singleton
    config.singletons.AppConfig = true
end)

-- build an instance of the entry point class, injecting your dependencies
local app = appModule.getInstance("example.App")

app:run()
```

---

Note this library supports both standard Lua classes and functional style classes:

*Lua Classes*

```lua
-- SomeClass.lua
local SomeClass = {}
SomeClass.__index = SomeClass

function SomeClass.new(val)
    return setmetatable({}, SomeClass)
end

function SomeClass.method(self)
    -- do stuff
end

return SomeClass
```

declaration: `local instance = SomeClass.new(val)`

*Functional Style*
```lua
local SomeClass = function(val)
    local iAmPrivate = "secretStuff"

    local method = function()
        -- do stuff
    end

    return 
    {
        method = method
    }
end

return SomeClass
```

declaration: `local instance = SomeClass(val)`

----

See the example app in `example.lua` to get a full view of how to configure an application to use this Dependency injection library.
