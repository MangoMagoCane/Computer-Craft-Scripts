-- VERSION 1.04
-- AUTOMATED STRIP MINER

local args = { ... }
local stripLen = tonumber(args[1])
local stripNum = tonumber(args[2])
local stripDist = tonumber(args[3])

function main(stripLen, stripNum, stripDist)
	if stripDist < 0 then
		print("YOU IDIOT!")
		os.exit()
	end
	-- Start position:
	for _ = 1, stripDist do
		digForward()
	end
	for i = 1, stripNum do
		turtle.turnRight()
		for _ = 1, stripLen do
			digForward()
		end
		turtle.turnLeft()
		turtle.turnLeft()
		for _ = 1, stripLen do
			turtle.forward()
		end
		-- Dig left strip:
		for _ = 1, stripLen do
			digForward()
		end
		turtle.turnLeft()
		turtle.turnLeft()
		for _ = 1, stripLen do
			turtle.forward()
		end
		-- Face the direction of home chest:
		turtle.turnRight()
		homeAndBack(i, stripDist)
	end
end

function digForward()
	while not turtle.forward() do
		turtle.dig()
	end
	turtle.digUp()
end

function homeAndBack(curNum, stripDist)
	for _ = 1, (curNum * stripDist) do
		turtle.forward()
	end
	for i = 1, 16 do
		turtle.select(i)
		turtle.drop()
	end
	turtle.turnLeft()
	turtle.turnLeft()
	for _ = 1, (curNum * stripDist) do
		turtle.forward()
	end
end

if not (main(stripLen, stripNum, stripDist)) then
	print("Usage: stripper [Length of strips] [Number of strips] [Blocks between strips]")
	print("Please put a chest behind the turtle's start position")
end
