-- VERSION 1.02
-- AUTOMATED STRIP MINER

local args = { ... }
local stripLen = args[1]
local stripNum = args[2]
local stripDist = args[3]

function main(stripLen, stripNum, stripDist)
  if (stripDist < 0) then
    print("YOU IDIOT!")
    os.exit()
  end
  -- Start position:
  for i = 1, stripDist do
    digForward()
  end
  for i = 1, stripNum do
    turtle.turnRight()
    for j = 1, stripLen do
      digforward()
      turtle.turnLeft()
      turtle.turnLeft()
    end
    for j = 1, stripLen do
      turtle.forward()
    end
    -- Dig left strip:
    for j = 1, stripLen do
      turtle.digForward()
      turtle.turnLeft()
      turtle.turnLeft()
    end
    for j = 1, stripLen do
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
  for i = 1, curNum * stripDist do
    turtle.forward()
  end
  for i = 1, 16 do
    turtle.select(i)
    turtle.drop()
  end
  turtle.turnLeft()
  turtle.turnLeft()
  for i = 1, curNum * stripDist do
    turtle.forward()
  end
end

if not (main(stripLen, stripNum, stripDist)) then
  print("Usage: stripper [Length of strips] [Number of strips] [Blocks between strips]")
  print("Please put a chest behind the turtle's start position")
end
