-- [uint col, uint row, uint depth, nil|"R"|"r" horzDir, nil|"U"|"u" vertDir]
local args = { ... }
local col = tonumber(args[1])
local row = tonumber(args[2])
local depth = tonumber(args[3])
local horzDir = args[4]
local vertDir = args[5]

local turnDir1, turnDir2, vertDig, vertMove
local clearLine = false
local blocksMined = 0
local i = 0

if (horzDir == "R" or horzDir == "r") then
  turnDir1 = turtle.turnRight
  turnDir2 = turtle.turnLeft
else
  turnDir1 = turtle.turnLeft
  turnDir2 = turtle.turnRight
end

if (vertDir == "U" or vertDir == "u") then
  vertDig = turtle.digUp
  vertMove = turtle.up
else
  vertDig = turtle.digDown
  vertMove = turtle.down
end

function main()
  return mineLayers(col, row, depth)
end

function digForward()
  while (not turtle.forward()) do
    turtle.dig()
    blocksMined = blocksMined + 1
  end
end

function logStat(statText, stat)
  if (clearLine) then
    term.clearLine()
  else
    clearLine = true
  end
  term.write(statText .. ": ")
  print(stat .. "\n")
  return clearLine
end

function logStats()
  term.clear()
  logStat("on layer", i)
  logStat("blocks mined", blocksMined)
end

function mineLayers(col, row, depth)
  for i = 1, depth do
    if (turtle.getFuelLevel() == 0) then
      local dotCount = 0
      term.write("err: turtle ran out of fuel, waiting to be refilled")
      local oldx, oldy = term.getCursorPos()
      oldx = oldx + 1
      while (not turtle.refuel()) do
        term.setCursorPos(oldx, oldy)
        term.clearLine()
        for _ = 1, dotCount + 1 do
          term.write(".")
        end
        dotCount = (dotCount + 1) % 3
        term.write("\n")
      end
      term.setTextColor(colors.green)
      term.write("refuel success! continuing process\n")
      clearLine = false;
    end

    logStats("on layer", i)

    for j = 1, row do
      for _ = 1, col - 1 do
        digForward()
      end

      if (j == row) then
        break
      end

      if (j % 2 == 1) then
        turnDir1()
        digForward()
        turnDir1()
      else
        turnDir2()
        digForward()
        turnDir2()
      end
    end

    if (row % 2 == 1) then
      turnDir1()
      turnDir1()
      for _ = 1, col - 1 do
        digForward()
      end
    end
    turnDir1()
    for _ = 1, row - 1 do
      digForward()
    end

    turnDir1()
    if (i == depth) then
      break
    end
    vertDig()
    vertMove()
  end

  return 0;
end

main()
