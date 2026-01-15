local difficulty = {}

local base_speed = 240
local speed_multiplier = 1
local elapsed = 0

function difficulty.load()
  difficulty.reset()
end

function difficulty.reset()
  speed_multiplier = 1
  elapsed = 0
end

function difficulty.update(dt)
  elapsed = elapsed + dt

  -- incremento velocita: ogni 30 secondi aumenta lo speed multiplier
  if elapsed >= 30 then
    elapsed = elapsed - 30
    speed_multiplier = speed_multiplier + 0.1
  end
end

function difficulty.get_speed()
  return base_speed * speed_multiplier
end

return difficulty
