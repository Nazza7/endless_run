local score = {}

local points = 0
local coins = 0

function score.load()
  score.reset()
end

function score.reset()
  points = 0
  coins = 0
end

function score.update(dt, speed)
  -- incremento distanza: 1 metro = 15px, punti aumentano con la velocita
  points = points + (speed * dt) / 15
end

function score.add_coin()
  coins = coins + 1
  points = points + 100
end

function score.get_points()
  return math.floor(points)
end

function score.get_coins()
  return coins
end

return score
