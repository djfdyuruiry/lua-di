package = "lua-di"
version = "0.5-0"
source = {
    url = "git://github.com/djfdyuruiry/lua-di.git",
    tag = "v0.5"
}
description = {
        summary = "Pure Lua dependency injection library that supports constructor based injection",
        detailed = [[
            See: https://github.com/djfdyuruiry/lua-di/blob/master/README.md

            Created by djfdyuruiry: https://github.com/djfdyuruiry
        ]],
        license = "MIT",
}
dependencies = {
    "lua >= 5.1"
}
build = {
    type = "builtin",
    modules = {
        ["luaDi.DependencyInjectionModule"] = "luaDi.DependencyInjectionModule.lua"
    },
    copy_directories = {}
}
