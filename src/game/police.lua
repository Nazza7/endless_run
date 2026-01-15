local police = {}

local danger_timer = 0
local is_danger = false

function police.load()
  police.reset()
end

function police.reset()
  danger_timer = 0
  is_danger = false
end

function police.update(dt)
  -- Danger Mode: conta alla rovescia la finestra errori
  if is_danger then
    danger_timer = danger_timer - dt
    if danger_timer <= 0 then
      danger_timer = 0
      is_danger = false
    end
  end
end

function police.on_obstacle_hit()
  -- gestione errori: primo errore attiva Danger, secondo entro 10s = Game Over
  if not is_danger then
    is_danger = true
    danger_timer = 10
    return false
  end

  return true
end

function police.is_danger()
  return is_danger
end

function police.draw()
  if is_danger then
    love.graphics.setColor(1, 0.2, 0.2, 0.4)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
  end
end

return police
