-- Version 1.0
-- Usage: printPage [string to be printed on paper] [side of computer printer is touching]
local args = { ... }
local printer = peripheral.wrap("right")
local printString = args[1]
local wrap = args[2]

if printer.newPage() then
	if printer.write(printString) then
		print("Successful write operation")
	else
		print("Writing error!")
	end
else
	print("Print error!")
end
printer.endPage()
