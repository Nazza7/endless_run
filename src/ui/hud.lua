local hud = {}

function hud.load()
end

function hud.draw(points, coins, is_danger)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Score: " .. points, 20, 20)
  love.graphics.print("Coins: " .. coins, 20, 40)
  if is_danger then
    love.graphics.setColor(1, 0.3, 0.3, 1)
    love.graphics.print("DANGER", 20, 60)
  end
  love.graphics.setColor(1, 1, 1, 1)
end

return hud
