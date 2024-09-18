-- VERSION 1.0
local args = { ... }
link = "https://raw.githubusercontent.com/MangoMagoCane/Computer-Craft-Scripts/refs/heads/main/"..args[1]..".lua"
if http.checkURL(link) then
  code = http.get(link)
  codeText = code.readAll()
  file = fs.open("git/"..args[1],"w")
  file.write(codeText)
  file.close()
else
  print("Invalid link")
end
