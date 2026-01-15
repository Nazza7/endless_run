local world = {}

local ground_y = 360

function world.load()
  world.reset()
end

function world.reset()
end

function world.update(dt)
end

function world.draw()
  love.graphics.setColor(0.15, 0.15, 0.2, 1)
  love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.setColor(0.2, 0.2, 0.2, 1)
  love.graphics.rectangle("fill", 0, ground_y, love.graphics.getWidth(), love.graphics.getHeight() - ground_y)
  love.graphics.setColor(1, 1, 1, 1)
end

return world
