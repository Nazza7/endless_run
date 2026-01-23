local collision = require("src.game.collision")

local obstacles = {}

local list = {}
local spawn_timer = 0
local spawn_interval = 2.2

function obstacles.load()
  obstacles.reset()
end

function obstacles.reset()
  list = {}
  spawn_timer = 0
end

local function spawn_obstacle()
  local kind = (math.random() < 0.5) and "low" or "high"
  local height = (kind == "low") and 40 or 80
  local y = (kind == "low") and 360 or 320
  table.insert(list, {
    x = 820,
    y = y - height,
    w = 50,
    h = height,
    kind = kind,
  })
end

function obstacles.update(dt, speed)
  spawn_timer = spawn_timer + dt
  if spawn_timer >= spawn_interval then
    spawn_timer = spawn_timer - spawn_interval
    spawn_obstacle()
  end

  for i = #list, 1, -1 do
    list[i].x = list[i].x - speed * dt
    if list[i].x + list[i].w < 0 then
      table.remove(list, i)
    end
  end
end

function obstacles.draw()
  for _, obstacle in ipairs(list) do
    if obstacle.kind == "low" then
      love.graphics.setColor(0.2, 0.2, 0.2, 1)
    else
      love.graphics.setColor(0.1, 0.1, 0.1, 1)
    end
    love.graphics.rectangle("fill", obstacle.x, obstacle.y, obstacle.w, obstacle.h)
  end
  love.graphics.setColor(1, 1, 1, 1)
end

function obstacles.check_collision(hitbox, player_state)
  for _, obstacle in ipairs(list) do
    if collision.aabb(hitbox, obstacle) then
      if obstacle.kind == "low" and player_state == "Jumping" then
        goto continue
      end
      if obstacle.kind == "high" and player_state == "Sliding" then
        goto continue
      end
      return true
    end
    ::continue::
  end
  return false
end

return obstacles
