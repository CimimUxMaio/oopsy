rockspec_format = "3.0"
package = "luaoop"
version = "1.0-1"

source = {
  url = "git://github.com/CimimUxMaio/luaoop",
}

description = {
  homepage = "git://github.com/CimimUxMaio/luaoop",
  summary = "A very simple and straight to the point object-oriented programming library for Lua.",
  license = "MIT",
}

build = {
  type = "builtin",
  modules = {
    luaoop = "src/luaoop.lua",
  },
}

test_dependencies = {
  "busted",
}

test = {
  type = "busted",
}
