# neosess

## ✨Installation

Packer.nvim:
```
use {
  "ksaito422/neosess",
  config = function()
    require("neosess").setup({})
  end,
}
```

## ⚙️Configuration

`session_path` is set to `~/.config/nvim/sessions` by default.
If you want to change the location of the session file, define it as follows.
```
use {
  "ksaito422/neosess",
  config = function()
    require("neosess").setup({
        session_path = "~/sessions"
      })
  end,
}
```

## ⚡️Commands

- `NeosessSave <session name>` Save the session
- `NeosessList` View saved sessions and expand selected sessions to buffer

## ⛓️Compatibility

Tested with:

```
NVIM v0.9.0
Build type: Release
LuaJIT 2.1.0-beta3 
```
