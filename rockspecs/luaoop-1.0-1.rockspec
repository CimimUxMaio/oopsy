rockspec_format = "3.0"
package = "luaoop"
version = "1.0-1"
source = {
  url = "https://github.com/CimimUxMaio/luaoop",
}
description = {
  homepage = "https://github.com/CimimUxMaio/luaoop",
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
