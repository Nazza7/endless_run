local player = {}

local ground_y = 360
local gravity = 1200
local jump_velocity = -520
local slide_duration = 0.5

local state = "Running"
local y = ground_y
local velocity_y = 0
local slide_timer = 0

function player.load()
  player.reset()
end

function player.reset()
  state = "Running"
  y = ground_y
  velocity_y = 0
  slide_timer = 0
end

function player.set_dead()
  state = "Dead"
  velocity_y = 0
  slide_timer = 0
end

function player.handle_input(key)
  if state == "Dead" then
    return
  end
  if (key == "space" or key == "up") and state == "Running" then
    state = "Jumping"
    velocity_y = jump_velocity
  elseif (key == "down" or key == "s") and state == "Running" then
    state = "Sliding"
    slide_timer = slide_duration
  end
end

function player.update(dt)
  if state == "Dead" then
    return
  end
  if state == "Jumping" then
    velocity_y = velocity_y + gravity * dt
    y = y + velocity_y * dt
    if y >= ground_y then
      y = ground_y
      velocity_y = 0
      state = "Running"
    end
  elseif state == "Sliding" then
    slide_timer = slide_timer - dt
    if slide_timer <= 0 then
      slide_timer = 0
      state = "Running"
    end
  end
end

function player.draw()
  local width = 40
  local height = (state == "Sliding") and 30 or 60
  if state == "Dead" then
    height = 40
  end
  love.graphics.rectangle("fill", 80, y - height, width, height)
end

function player.get_hitbox()
  local width = 40
  local height = (state == "Sliding") and 30 or 60
  if state == "Dead" then
    height = 40
  end
  return { x = 80, y = y - height, w = width, h = height }
end

return player
