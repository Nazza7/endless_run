local collision = require("src.game.collision")

local coins = {}

local list = {}
local spawn_timer = 0
local spawn_interval = 3.5

function coins.load()
  coins.reset()
end

function coins.reset()
  list = {}
  spawn_timer = 0
end

local function spawn_coin()
  table.insert(list, {
    x = 820,
    y = 260,
    w = 26,
    h = 26,
  })
end

function coins.update(dt, speed)
  spawn_timer = spawn_timer + dt
  if spawn_timer >= spawn_interval then
    spawn_timer = spawn_timer - spawn_interval
    spawn_coin()
  end

  for i = #list, 1, -1 do
    list[i].x = list[i].x - speed * dt
    if list[i].x + list[i].w < 0 then
      table.remove(list, i)
    end
  end
end

function coins.draw()
  love.graphics.setColor(1, 0.8, 0.1, 1)
  for _, coin in ipairs(list) do
    love.graphics.circle("fill", coin.x + coin.w / 2, coin.y + coin.h / 2, coin.w / 2)
  end
  love.graphics.setColor(1, 1, 1, 1)
end

function coins.check_collision(hitbox)
  for i = #list, 1, -1 do
    if collision.aabb(hitbox, list[i]) then
      table.remove(list, i)
      return true
    end
  end
  return false
end

return coins
