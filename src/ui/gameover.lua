local gameover = {}

function gameover.load()
end

function gameover.update(dt)
end

function gameover.draw(points)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Game Over", 330, 200)
  love.graphics.print("Score: " .. points, 330, 230)
  love.graphics.print("Press Enter/Space to Restart", 250, 260)
end

return gameover
