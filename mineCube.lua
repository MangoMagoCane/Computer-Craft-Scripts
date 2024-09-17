-- [uint col, uint row, uint depth, void|"R"|"r" dir]
local args = { ... }
local col = tonumber(args[1])
local row = tonumber(args[2])
local depth = tonumber(args[3])
local dir = args[4]

local turnDir1; local turnDir2;
if (dir == "R" or dir == "r") then
    turnDir1 = turtle.turnRight
    turnDir2 = turtle.turnLeft
else
    turnDir1 = turtle.turnLeft
    turnDir2 = turtle.turnRight
end

function main()
    for _ = 1, depth do
        mineLayer(col, row)
    end
end

function digForward()
    while (not turtle.forward()) do
        turtle.dig()
    end
end

function mineLayer(col, row)
    for i = 1, row - 1 do
        for _ = 1, col do
            digForward()
        end

        if (i % 2 == 1) then
            turnDir1()
            digForward()
            turnDir1()
        else
            turnDir2()
            digForward()
            turnDir2()
        end
    end
    for _ = 1, col do
        digForward()
    end

    turnDir1()
    if (row % 2 == 1) then
        turnDir1()
        for _ = 1, col do
            turtle.forward()
        end
    end
    turnDir1()
    for _ = 1, row do
        turtle.forward()
    end

    turnDir1()
    turtle.digDown()
    turtle.down()
end

main()
