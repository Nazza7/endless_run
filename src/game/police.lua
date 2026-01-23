local police = {}

local danger_timer = 0
local is_danger = false
local danger_duration = 10
local siren_source = nil
local siren_volume = 0.5

function police.load()
  if not siren_source then
    local sample_rate = 44100
    local duration = 1
    local sound_data = love.sound.newSoundData(sample_rate * duration, sample_rate, 16, 1)
    for i = 0, sound_data:getSampleCount() - 1 do
      local t = i / sample_rate
      local phase = (t % 1)
      local frequency = (phase < 0.5) and 660 or 880
      local sample = math.sin(2 * math.pi * frequency * t) * 0.4
      sound_data:setSample(i, sample)
    end
    siren_source = love.audio.newSource(sound_data, "static")
    siren_source:setLooping(true)
    siren_source:setVolume(siren_volume)
  end
  police.reset()
end

function police.reset()
  danger_timer = 0
  is_danger = false
  if siren_source then
    siren_source:stop()
  end
end

function police.update(dt)
  -- Danger Mode: conta alla rovescia la finestra errori
  if is_danger then
    danger_timer = danger_timer - dt
    if danger_timer <= 0 then
      danger_timer = 0
      is_danger = false
      if siren_source then
        siren_source:stop()
      end
    end
  end
end

function police.on_obstacle_hit()
  -- gestione errori: primo errore attiva Danger, secondo entro 10s = Game Over
  if not is_danger then
    is_danger = true
    danger_timer = danger_duration
    if siren_source then
      siren_source:play()
    end
    return false
  end

  if siren_source then
    siren_source:stop()
  end
  is_danger = false
  danger_timer = 0
  return true
end

function police.is_danger()
  return is_danger
end

function police.get_timer()
  return danger_timer
end

function police.get_duration()
  return danger_duration
end

function police.draw()
  local width = love.graphics.getWidth()
  local ground_y = 360
  local base_y = ground_y - 40
  local far_x = width - 90
  local near_x = width - 140
  if is_danger then
    love.graphics.setColor(0.2, 0.6, 1, 1)
    love.graphics.rectangle("fill", near_x, base_y - 20, 60, 20)
    love.graphics.setColor(0.8, 0.9, 1, 1)
    love.graphics.rectangle("fill", near_x + 10, base_y - 30, 20, 10)
    love.graphics.setColor(1, 1, 1, 1)
  else
    love.graphics.setColor(0.2, 0.4, 0.9, 0.6)
    love.graphics.rectangle("fill", far_x, base_y - 12, 40, 12)
    love.graphics.setColor(0.8, 0.9, 1, 0.6)
    love.graphics.rectangle("fill", far_x + 8, base_y - 20, 16, 8)
    love.graphics.setColor(1, 1, 1, 1)
  end
  if is_danger then
    local pulse = 0.25 + 0.15 * math.sin(love.timer.getTime() * 4)
    love.graphics.setColor(1, 0.2, 0.2, pulse)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1)
  end
end

return police
