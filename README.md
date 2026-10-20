# switch

A chainable `switch` for FiveM Lua.

## Install

Copy `switch.lua` into your resource and load it in your `fxmanifest.lua`:

```lua
lua54 'yes'
shared_script 'switch.lua'
```

`lua54 'yes'` is required.

## Usage

`switch(value)` starts a chain. `:case(...)` takes one or more values followed by a handler, and the first matching case wins. `:default(fn)` runs if nothing matched. `:get()` returns whatever the handler returned.

```lua
local rate = switch(GetVehicleClass(veh))
    :case(8, function() return 0.6 end)
    :default(function() return 1.0 end)
    :get()
```

### Multiple cases

Cases are checked top to bottom and the first match wins.

```lua
local label = switch(GetVehicleClass(veh))
    :case(8, function() return 'motorcycle' end)
    :case(13, function() return 'bicycle' end)
    :case(14, function() return 'boat' end)
    :case(15, function() return 'helicopter' end)
    :case(16, function() return 'plane' end)
    :default(function() return 'car' end)
    :get()
```

### Multiple values per case

```lua
local ok, reason = switch(state)
    :case('locked', 'broken', function() return false, 'unavailable' end)
    :default(function() return true end)
    :get()
```

### Multiple return values

`:get()` returns every value the handler returned.

```lua
local function getWheels(class)
    local _, _, wheels <const> = switch(class)
        :case(8, function() return 'bike', 0.6, 2 end)
        :default(function() return 'car', 1.0, 4 end)
        :get()
    return wheels
end
```

Wrap the call in parentheses to keep only the first value:

```lua
local function getLabel(class)
    return (switch(class)
        :case(8, function() return 'bike', 0.6, 2 end)
        :default(function() return 'car', 1.0, 4 end)
        :get())
end
```

### Passing arguments to handlers

Inline handlers can use surrounding locals directly. Any extra arguments given to `switch` are passed to the handler, which is useful when the handlers are named functions defined elsewhere:

```lua
local function policeBuy(src, item, amount, price) ... end
local function deny(src) ... end

switch(job, source, item, amount, price)
    :case('police', policeBuy)
    :default(deny)
```
