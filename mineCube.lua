-- [uint col, uint row, uint depth, nil|"R"|"r" horzDir, nil|"U"|"u" vertDir]
local args = { ... }
local col = tonumber(args[1])
local row = tonumber(args[2])
local depth = tonumber(args[3])
local horzDir = args[4]
local vertDir = args[5]

local turnDir1, turnDir2, vertDig, vertMove
local log_blocksMined = 0
local log_layer = 1

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

function clearScreen()
  term.clear()
  term.setCursorPos(1, 1)
end

function logStats()
  clearScreen()
  local quantizedPercent = math.ceil((log_layer / depth) * 10)
  local progressBar = ""
  for i = 1, quantizedPercent do
    progressBar = progressBar .. "#"
  end
  for i = 1, (10 - quantizedPercent) do
    progressBar = progressBar .. "-"
  end
  print("on layer: " .. log_layer .. "/" .. depth .. " [" .. progressBar .. "]")
  print("blocks mined: " .. log_blocksMined)
end

function digForward()
  while (not turtle.forward()) do
    if (turtle.dig()) then
      log_blocksMined = log_blocksMined + 1
      logStats()
    end
  end
end

function mineLayers(col, row, depth)
  for i = 1, depth do
    log_layer = i
    if (turtle.getFuelLevel() == 0) then
      local dotCount = 0
      while (not turtle.refuel()) do
        local dotStr = ""
        clearScreen()
        for _ = 1, dotCount + 1 do
          dotstr = dotStr .. "."
        end
        print("err: turtle ran out of fuel, waiting to be refilled" .. dotStr)
        dotCount = (dotCount + 1) % 3
      end
      clearScreen()
      print("refuel success! continuing process")
    end

    logStats()

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

  print("Done!")
  return 0;
end

main()
