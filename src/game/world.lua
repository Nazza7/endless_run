local world = {}

local ground_y = 360
local ground_offset = 0
local bg_offset = 0
local bg_speed_ratio = 0.3

function world.load()
  world.reset()
end

function world.reset()
  ground_offset = 0
  bg_offset = 0
end

function world.update(dt, speed)
  ground_offset = (ground_offset + speed * dt) % love.graphics.getWidth()
  bg_offset = (bg_offset + speed * bg_speed_ratio * dt) % love.graphics.getWidth()
end

function world.draw()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()

  love.graphics.setColor(0.15, 0.15, 0.2, 1)
  love.graphics.rectangle("fill", 0, 0, width, height)

  love.graphics.setColor(0.1, 0.12, 0.18, 1)
  for x = -width, width, 120 do
    love.graphics.rectangle("fill", x - bg_offset, ground_y - 120, 80, 80)
  end

  love.graphics.setColor(0.2, 0.2, 0.2, 1)
  love.graphics.rectangle("fill", -ground_offset, ground_y, width * 2, height - ground_y)
  love.graphics.setColor(1, 1, 1, 1)
end

return world
