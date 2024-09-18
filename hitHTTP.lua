-- VERSION 1.1
-- [string filename]
local args = { ... }
local filename = args[1]

local url = "https://raw.githubusercontent.com/MangoMagoCane/Computer-Craft-Scripts/refs/heads/main/" ..
    filename .. ".lua"
local path = "git/" .. filename

if http.checkURL(url) then
  local handle = http.get(url)
  local codeText = handle.readAll()
  fs.delete(path)
  local file = fs.open(path, "w")
  file.write(codeText)
  file.close()
else
  print("Invalid link")
end
