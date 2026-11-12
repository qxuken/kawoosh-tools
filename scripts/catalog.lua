-- Release-time loader for data definitions. Kawoosh consumes only the JSON.
-- Lua 5.4+; no package dependencies and no recipe placeholder expansion.
local arrays = setmetatable({}, { __mode = "k" })
local function array(t) arrays[t] = true; return t end
local function fail(file, recipe, field, message)
  error(file .. ": " .. recipe .. "." .. field .. ": " .. message, 0)
end
local function keys(t)
  local result = {}
  for key in pairs(t) do result[#result + 1] = key end
  table.sort(result, function(a, b) return tostring(a) < tostring(b) end)
  return result
end
local function text(v, file, at, field, empty)
  if type(v) ~= "string" then fail(file, at, field, "must be a string") end
  if not empty and not v:find("%S") then fail(file, at, field, "must not be empty") end
  if v:find("\0", 1, true) then fail(file, at, field, "must not contain NUL") end
  if not utf8.len(v) then fail(file, at, field, "must be UTF-8") end
end
local function object(v, file, at, field)
  if type(v) ~= "table" or arrays[v] then fail(file, at, field, "must be a table with string keys") end
  for key in pairs(v) do
    if type(key) ~= "string" then fail(file, at, field, "must have string keys") end
  end
end
local function list(v, file, at, field, nonempty)
  if type(v) ~= "table" then fail(file, at, field, "must be a list") end
  local count = 0
  for key in pairs(v) do
    if math.type(key) ~= "integer" or key < 1 then fail(file, at, field, "must be a dense list") end
    count = count + 1
  end
  if count ~= #v then fail(file, at, field, "must be a dense list") end
  for i = 1, count do if rawget(v, i) == nil then fail(file, at, field, "must be a dense list") end end
  if nonempty and count == 0 then fail(file, at, field, "must not be empty") end
  arrays[v] = true
end
local function strings(v, file, at, field, nonempty)
  list(v, file, at, field, nonempty)
  for i, item in ipairs(v) do text(item, file, at, field .. "[" .. i .. "]", true) end
end
local function fields(v, allowed, file, at)
  object(v, file, at, "table")
  local accepted = {}
  for _, field in ipairs(allowed) do accepted[field] = true end
  for _, key in ipairs(keys(v)) do
    if not accepted[key] then fail(file, at, key, "unsupported field") end
  end
end
local function integer(v, file, at, field, minimum)
  if math.type(v) ~= "integer" or v < minimum then
    fail(file, at, field, "must be an integer >= " .. minimum)
  end
end
local function contains(items, value)
  for _, item in ipairs(items) do if item == value then return true end end
  return false
end
local function json_value(v, file, at, field, seen)
  local kind = type(v)
  if kind == "number" then
    if v ~= v or v == math.huge or v == -math.huge then fail(file, at, field, "must be a finite JSON number") end
  elseif kind == "string" then
    if not utf8.len(v) then fail(file, at, field, "must be UTF-8") end
  elseif kind == "table" then
    if seen[v] then fail(file, at, field, "cyclic JSON table") end
    seen[v] = true
    if arrays[v] or next(v) ~= nil and type(next(v)) == "number" then
      list(v, file, at, field)
      for i, item in ipairs(v) do json_value(item, file, at, field .. "[" .. i .. "]", seen) end
    else
      object(v, file, at, field)
      for _, key in ipairs(keys(v)) do
        if not utf8.len(key) then fail(file, at, field, "JSON key must be UTF-8") end
        json_value(v[key], file, at, field .. "." .. key, seen)
      end
    end
    seen[v] = nil
  elseif kind ~= "boolean" then fail(file, at, field, "unsupported JSON value: " .. kind) end
end
local function install(v, file, at)
  if type(v) == "string" then text(v, file, at, "install", true); return end
  object(v, file, at, "install")
  if next(v) == nil then fail(file, at, "install", "must name a platform or package manager") end
  local platforms, managers = { "mac", "linux", "windows" }, { "npm", "pip", "cargo", "go", "dotnet" }
  local platform = true
  for key in pairs(v) do if not contains(platforms, key) then platform = false end end
  if platform then
    for _, key in ipairs(keys(v)) do text(v[key], file, at, "install." .. key, true) end
    return
  end
  fields(v, { "npm", "pip", "cargo", "go", "dotnet", "args" }, file, at .. ".install")
  local selected = {}
  for _, key in ipairs(managers) do if v[key] ~= nil then selected[#selected + 1] = key end end
  if #selected ~= 1 then fail(file, at, "install", "must name exactly one package manager") end
  local manager = selected[1]
  if type(v[manager]) == "string" then text(v[manager], file, at, "install." .. manager) else
    strings(v[manager], file, at, "install." .. manager, true)
    for _, name in ipairs(v[manager]) do text(name, file, at, "install." .. manager) end
  end
  if v.args ~= nil then strings(v.args, file, at, "install.args") end
end
local function recipe(row, kind, file, index)
  local at = kind .. "[" .. index .. "]"
  object(row, file, at, "row")
  text(row.name, file, at, "name")
  at = kind .. "." .. row.name
  if not row.name:match("^[a-zA-Z0-9_.-]+$") then fail(file, at, "name", "invalid recipe name") end
  integer(row.order, file, at, "order", 0)
  text(row.cmd, file, at, "cmd")
  local allowed = { "order", "name", "cmd", "args", "languages", "install" }
  local extra = kind == "servers" and { "roots", "when", "settings", "init", "with", "relay", "answers" }
    or { "when", "node", "range", "probe", "timeout_ms", "enabled" }
  for _, key in ipairs(extra) do allowed[#allowed + 1] = key end
  fields(row, allowed, file, at)
  for _, key in ipairs({ "args", "languages", "roots", "with", "range" }) do
    if row[key] ~= nil then strings(row[key], file, at, key) end
  end
  if row.install ~= nil then install(row.install, file, at) end
  if kind == "servers" then
    if contains({ "enabled", "diagnostics", "inlay_hints", "idle_stop_secs", "languages", "ensure_installed", "check_updates" }, row.name) then fail(file, at, "name", "reserved server setting") end
    if row.when ~= nil then strings(row.when, file, at, "when") end
    for _, key in ipairs({ "settings", "init", "answers" }) do
      if row[key] ~= nil then
        if key == "answers" then object(row[key], file, at, key) end
        json_value(row[key], file, at, key, {})
      end
    end
    if row.relay ~= nil then
      list(row.relay, file, at, "relay")
      for i, relay in ipairs(row.relay) do
        local key = "relay[" .. i .. "]"
        object(relay, file, at, key)
        fields(relay, { "method", "to", "command", "reply" }, file, at .. "." .. key)
        for _, field in ipairs({ "method", "to", "command", "reply" }) do text(relay[field], file, at, key .. "." .. field) end
      end
    end
  else
    if contains({ "auto", "lsp", "selection", "ensure_installed", "check_updates" }, row.name) then fail(file, at, "name", "reserved formatter name") end
    strings(row.languages, file, at, "languages", true)
    for _, key in ipairs({ "node", "enabled" }) do
      if row[key] ~= nil and type(row[key]) ~= "boolean" then fail(file, at, key, "must be a boolean") end
    end
    if row.timeout_ms ~= nil then integer(row.timeout_ms, file, at, "timeout_ms", 1) end
    if row.when ~= nil then
      if type(row.when) == "string" then text(row.when, file, at, "when") else strings(row.when, file, at, "when") end
    end
    if row.probe ~= nil then
      object(row.probe, file, at, "probe")
      for _, language in ipairs(keys(row.probe)) do
        if not contains(row.languages, language) then fail(file, at, "probe." .. language, "language is absent from languages") end
        text(row.probe[language], file, at, "probe." .. language)
      end
    end
  end
end

local function quote(value)
  local escapes = { ['"'] = '\\"', ['\\'] = '\\\\', ['\b'] = '\\b', ['\f'] = '\\f', ['\n'] = '\\n', ['\r'] = '\\r', ['\t'] = '\\t' }
  return '"' .. value:gsub('[%z\1-\31\\"]', function(c) return escapes[c] or string.format("\\u%04x", c:byte()) end) .. '"'
end
local function encode(value)
  local kind = type(value)
  if kind == "string" then return quote(value) end
  if kind == "number" then return math.type(value) == "integer" and tostring(value) or string.format("%.17g", value) end
  if kind == "boolean" then return tostring(value) end
  local parts = {}
  if arrays[value] then
    for i, item in ipairs(value) do parts[i] = encode(item) end
    return "[" .. table.concat(parts, ",") .. "]"
  end
  for _, key in ipairs(keys(value)) do parts[#parts + 1] = quote(key) .. ":" .. encode(value[key]) end
  return "{" .. table.concat(parts, ",") .. "}"
end

local function main()
  if not math.type or not utf8 then error("Lua 5.4 or newer is required", 0) end
  local release, focused, files = "dev", false, {}
  local i = 1
  while i <= #arg do
    if arg[i] == "--release" then i = i + 1; release = arg[i]
    elseif arg[i] == "--file" then i = i + 1; files[#files + 1] = assert(arg[i], "--file needs a path")
    elseif arg[i] == "--verify-file" then focused = true
    else error("unknown argument " .. arg[i], 0) end
    i = i + 1
  end
  if not release or not release:match("^[a-zA-Z0-9][a-zA-Z0-9._-]*$") then error("release must be a nonempty tag such as r2 or dev", 0) end
  if #files == 0 then error("no Lua recipe files", 0) end
  table.sort(files)
  local entries = { servers = {}, formatters = {} }
  for _, file in ipairs(files) do
    local chunk, message = loadfile(file, "t", { array = array })
    if not chunk then fail(file, "recipes", "Lua", message) end
    local ok, data = pcall(chunk)
    if not ok then fail(file, "recipes", "Lua", tostring(data)) end
    fields(data, { "servers", "formatters" }, file, "recipes")
    local count = 0
    for _, kind in ipairs({ "servers", "formatters" }) do
      local rows = data[kind] or {}
      list(rows, file, kind, "rows")
      for index, row in ipairs(rows) do
        recipe(row, kind, file, index)
        entries[kind][#entries[kind] + 1] = { row = row, file = file }
        count = count + 1
      end
    end
    if count == 0 then fail(file, "recipes", "rows", "file has no recipes") end
  end
  local catalog = { schema = 1, release = release, servers = array {}, formatters = array {} }
  local servers = {}
  for _, kind in ipairs({ "servers", "formatters" }) do
    if not focused and #entries[kind] == 0 then error("empty " .. kind .. " catalog", 0) end
    table.sort(entries[kind], function(a, b) return a.row.order < b.row.order end)
    local names, orders = {}, {}
    for _, entry in ipairs(entries[kind]) do
      local row, file = entry.row, entry.file
      if names[row.name] then fail(file, kind .. "." .. row.name, "name", "duplicate name also in " .. names[row.name]) end
      if orders[row.order] then fail(file, kind .. "." .. row.name, "order", "duplicate order also in " .. orders[row.order]) end
      names[row.name], orders[row.order] = file, file
      if kind == "servers" then servers[row.name] = entry end
      local output = {}
      for key, value in pairs(row) do if key ~= "order" then output[key] = value end end
      catalog[kind][#catalog[kind] + 1] = output
    end
  end
  if not focused then
    local active, done = {}, {}
    local function dependencies(entry)
      local row, file = entry.row, entry.file
      if active[row.name] then fail(file, "servers." .. row.name, "with", "dependency cycle") end
      if done[row.name] then return end
      active[row.name] = true
      for _, name in ipairs(row.with or {}) do
        if not servers[name] then fail(file, "servers." .. row.name, "with", "unknown server " .. name) end
        dependencies(servers[name])
      end
      for _, relay in ipairs(row.relay or {}) do
        if not servers[relay.to] then fail(file, "servers." .. row.name, "relay.to", "unknown server " .. relay.to) end
      end
      active[row.name], done[row.name] = nil, true
    end
    for _, entry in ipairs(entries.servers) do dependencies(entry) end
  end
  local json = encode(catalog) .. "\n"
  if #json > 2097152 then error("generated catalog exceeds the runtime's 2 MiB limit", 0) end
  io.write(json)
end
local ok, message = pcall(main)
if not ok then io.stderr:write(tostring(message), "\n"); os.exit(1) end
