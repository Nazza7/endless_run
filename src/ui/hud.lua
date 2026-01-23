local hud = {}

function hud.load()
end

function hud.draw(points, coins, is_danger, danger_timer, danger_duration)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Score: " .. points, 20, 20)
  love.graphics.print("Coins: " .. coins, 20, 40)
  if is_danger then
    love.graphics.setColor(1, 0.3, 0.3, 1)
    love.graphics.print("DANGER", 20, 60)
    local width = 120
    local height = 8
    local x = 20
    local y = 80
    local ratio = 0
    if danger_duration > 0 then
      ratio = danger_timer / danger_duration
    end
    love.graphics.setColor(0.2, 0.05, 0.05, 1)
    love.graphics.rectangle("fill", x, y, width, height)
    love.graphics.setColor(1, 0.3, 0.3, 1)
    love.graphics.rectangle("fill", x, y, width * ratio, height)
  end
  love.graphics.setColor(1, 1, 1, 1)
end

return hud
