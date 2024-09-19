-- VERSION 1.1
-- ["git"|"val"|evan" method, string filename]
local args = { ... }
local method = args[1]
local filename = args[2]

local lookupTable = {
  git = "http://raw.githubusercontent.com/MangoMagoCane/Computer-Craft-Scripts/refs/heads/main/scripts/",
  val = "Not keeping my ip in here!!!",
  -- evan = nil
}

local address = lookupTable[method]
if (address == nil) then
  print("invalid method: " .. method)
  return -1
end

local url = address .. "/" .. filename .. ".lua"
if (not http.checkURL(url)) then
  print("Invalid URL")
  return -1
end

local path = method .. "/" .. filename
local handle = http.get(url)
local codeText = handle.readAll()
fs.delete(path)
local file = fs.open(path, "w")
file.write(codeText)
file.close()
