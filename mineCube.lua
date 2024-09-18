-- [uint col, uint row, uint depth, nil|"R"|"r" horzDir, nil|"U"|"u" vertDir]
local args = { ... }
local col = tonumber(args[1])
local row = tonumber(args[2])
local depth = tonumber(args[3])
local horzDir = args[4]
local vertDir = args[5]

local turnDir1, turnDir2, vertDig, vertMove;
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
    for _ = 1, depth do
        turtle.refuel()
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
    for _ = 1, row - 1 do
        turtle.forward()
    end

    turnDir1()
    vertDig()
    vertMove()
end

main()
