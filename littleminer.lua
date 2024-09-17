function digForward()
    while (not turtle.forward()) do
        turtle.dig()
    end
end

function mineLayer(row, col)
    for i = 1, row do
        for j = 1, col do
            digForward()
        end

        if (i < row) then
            if (i % 2 == 1) then
                turtle.turnLeft()
                digForward()
                turtle.turnLeft()
            else
                turtle.turnRight()
                digForward()
                turtle.turnRight()
            end
        end
    end

    turtle.turnLeft()
    if (row % 2 == 1) then
        turtle.turnLeft()
        for _ = 1, col do
            turtle.forward()
        end
    end
    turtle.turnLeft()
    for _ = 1, row do
        turtle.forward()
    end
    turtle.turnLeft()
    turtle.digDown()
    turtle.down()
end
