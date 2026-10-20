local select <const> = select
local setmetatable <const> = setmetatable
local pack <const> = table.pack
local unpack <const> = table.unpack

---@class Switch
---@field value any
---@field args? table handler args
---@field results? table handler returns
local Switch <const> = {}
Switch.__index = Switch

---@param self Switch
---@param fn function
---@return Switch
local function fire(self, fn)
	local args <const> = self.args
	self.results = args and pack(fn(unpack(args, 1, args.n))) or pack(fn())
	return self
end

---Extra args go to the handler
---@param v any
---@param ... any
---@return Switch
---@diagnostic disable-next-line: lowercase-global
function switch(v, ...)
	local self <const> = setmetatable({ value = v }, Switch)
	if select('#', ...) > 0 then
		self.args = pack(...)
	end
	return self
end

---Last arg is the handler
---:case('police', 'sheriff', function(...) end)
---@param ... any
---@return Switch
function Switch:case(...)
	if self.results then return self end

	local n <const> = select('#', ...)
	assert(n >= 2, 'switch:case expects at least one value and a handler')
	local fn <const> = select(n, ...)
	local v <const> = self.value

	if n == 2 then
		if v == (...) then return fire(self, fn) end
		return self
	end

	for i = 1, n - 1 do
		if v == select(i, ...) then return fire(self, fn) end
	end
	return self
end

---Runs if nothing matched
---@param fn function
---@return Switch
function Switch:default(fn)
	if self.results then return self end
	return fire(self, fn)
end

---Returns all handler values
---@return any ...
function Switch:get()
	local results <const> = self.results
	if not results then return end
	return unpack(results, 1, results.n)
end
