-- VERSION 1.1
-- [uint col, uint row, uint depth,]
-- ["-r" go right insead of left, "-u" go up instead of down, "-c", use a chest, "-e", use an enderchest]
-- ! current bug in the refuel logic, should probably run if any movement logic fails
local args = { ... }
local col = tonumber(args[1])
local row = tonumber(args[2])
local depth = tonumber(args[3])

if (col == nil or row == nil or depth == nil) then
  print("---------------------------------------")
  print("usage: mineCube col row depth [options]")
  print("optional parameters in any order:")
  print("\t-r go right insead of left")
  print('\t-u go up instead of down')
  print("\t-c [dist] use a chest")
  print("\t-ce use an ender chest")
  print('example: mineCube 5 2 3 -r -u -c')
  print('example: mineCube 3 3 3 -ce')
  return;
end

local goRight, goUp, useChest, useEnder, chestDistance = false, false, false, false, 0
local vertDigForward, vertMoveForward, vertDigBackword, vertMoveBackword, vertDrop
local turnDir1, turnDir2

local log_layer = 1
local log_col = 1
local log_row = 1
local log_blocksMined = 0

local i = 4
while i <= #args do
  print(i)
  local currArg = args[i]
  if currArg == "-r" then
    goRight = true
  elseif currArg == "-u" then
    goUp = true
  elseif currArg == "-r" then
    goRight = true
  elseif string.sub(currArg, 1, 2) == "-c" then
    useChest = true
    print("foo")
    if string.sub(currArg, 3) == "e" then
      useEnder = true
    else
      chestDistance = tonumber(args[i + 1]) or 0
      if chestDistance ~= 0 then
        print(chestDistance)
        i = i + 1
      end
    end
  else
    print(currArg .. " is an invalid option")
    return -1;
  end
  i = i + 1
end

if goRight then
  turnDir1 = turtle.turnRight
  turnDir2 = turtle.turnLeft
else
  turnDir1 = turtle.turnLeft
  turnDir2 = turtle.turnRight
end

if goUp then
  vertDigForward = turtle.digUp
  vertMoveForward = turtle.up
  vertDigBackword = turtle.digDown
  vertMoveBackword = turtle.down
  vertDrop = turtle.dropDown
else
  vertDigForward = turtle.digDown
  vertMoveForward = turtle.down
  vertDigBackword = turtle.digUp
  vertMoveBackword = turtle.up
  vertDrop = turtle.dropUp
end


function main()
  return mineLayers(col, row, depth)
end

function clearScreen()
  term.clear()
  term.setCursorPos(1, 1)
end

function progressBar(numer, denom, steps)
  local quantizedPercent = math.floor((numer / denom) * steps)
  local progressBar = ""
  for i = 1, quantizedPercent do
    progressBar = progressBar .. "#"
  end
  for i = 1, (steps - quantizedPercent) do
    progressBar = progressBar .. "-"
  end
  return numer .. "/" .. denom .. " [" .. progressBar .. "]"
end

function logStats()
  local stepCount = 20
  clearScreen()
  print("on layer: " .. progressBar(log_layer, depth, stepCount))
  print("on row:   " .. progressBar(log_row, row, stepCount))
  print("on col:   " .. progressBar(log_col, col, stepCount))
  print("blocks mined: " .. log_blocksMined)
end

function digForward()
  logStats()
  while not turtle.forward() do
    if turtle.dig() then
      log_blocksMined = log_blocksMined + 1
      logStats()
    end
  end
end

function drop_items()
  for i = 1, 16 do
    local wait = false
    while turtle.getItemCount(i) > 0 do
      turtle.select(i)
      turtle.refuel(64)
      vertDrop()

      if wait then
        sleep(10)
        print("Chest is likely full! Waiting...")
      end -- avoid yield errors
      wait = true
    end
  end
end

function refuel()
  local dotCount = 0
  while turtle.getFuelLevel() == 0 do
    for i = 1, 16 do
      turtle.select(i)
      turtle.refuel()
    end
    local dotStr = ""
    for _ = 1, dotCount + 1 do
      dotstr = dotStr .. "."
    end
    clearScreen()
    print("err: turtle ran out of fuel, waiting to be refilled" .. dotStr)
    dotCount = (dotCount + 1) % 3
  end
  clearScreen()
  print("refuel success! continuing process")
  turtle.select(1)
end

function mineLayers(col, row, depth)
  for i = 1, depth do
    log_layer = i


    for j = 1, row do
      log_row = j
      for k = 1, col - 1 do
        log_col = k
        refuel()
        digForward()
      end

      log_col = col
      if j == row then
        break
      end
      if j % 2 == 1 then
        turnDir1()
        digForward()
        turnDir1()
      else
        turnDir2()
        digForward()
        turnDir2()
      end
    end

    if row % 2 == 1 then
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
    if i == depth then
      break
    end

    if useChest and turtle.getItemCount(15) ~= 0 then -- 15 slots full instead of 16 to minimize lost items
      clearScreen()
      if useEnder then
        print("DEPOSITING ITEMS IN ENDER CHEST")
      else
        print("RETURNING TO CHEST")
        local distance = i + chestDistance - 1
        for _ = 1, distance do
          vertDigBackword()
          vertMoveBackword()
        end
        drop_items()
        for _ = 1, distance do
          vertDigForward()
          vertMoveForward()
        end
      end
    end

    vertDigForward()
    vertMoveForward()
  end

  print("Done!")
  return 0;
end

main()
