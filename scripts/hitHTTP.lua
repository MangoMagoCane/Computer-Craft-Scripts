-- VERSION 1.1
-- ["git"|"val"|evan" method, string filename]
local args = { ... }
local method = args[1]
local filename = args[2]

local lookupTable = {
  git = "https://raw.githubusercontent.com/MangoMagoCane/Computer-Craft-Scripts/refs/heads/main/scripts",
  val = "http://127.0.0.1:8080",
  -- evan = nil
}

local address = lookupTable[method]
if (address == nil) then
  print("invalid method: " .. method ~= nil and method or "nil")
  return -1
end

local url = address .. "/" .. filename .. ".lua"
local success, message = http.checkURL(url)
if (not success) then
  print(url)
  print("Invalid URL:", message)
  return -1
end

local path = method .. "/" .. filename
local handle = http.get(url)
local codeText = handle.readAll()
fs.delete(path)
local file = fs.open(path, "w")
file.write(codeText)
file.close()
