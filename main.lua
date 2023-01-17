local World = require 'world'
local Vehicle = require 'vehicle'

local center = {
    x = love.graphics.getWidth() / 2,
    y = love.graphics.getHeight()/2
}

local mouse = {x=0, y=0}


local args = {
    position = center,
}

local test = Vehicle:new(args)

function love.draw()
    love.graphics.circle('fill', test.position.x, test.position.y, 16)
end

function love.update(dt)
    mouse.x, mouse.y = love.mouse.getPosition()
    test:flee(mouse)
    test:update(dt)
end
