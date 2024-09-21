local args = { ... }

local prevDir, currDir = nil, nil

for _ = 1, 20 do
  repeat
    currDir = math.random(0, 1)
  until currDir ~= prevDir

  prevDir = currDir
  if currDir == 0 then
    turtle.turnLeft()
  else
    turtle.turnLeft()
  end

  for _ = 1, math.random(3, 10) do
    while not turtle.forward() do
      turtle.dig()
    end
    turtle.digUp()
  end

  local moveDirChance = math.random()
  if moveDirChance < 0.1 then
    turtle.digDown()
    turtle.down()
  elseif moveDirChance < 0.2 then
    turtle.digUp()
    turtle.up()
  end
end
