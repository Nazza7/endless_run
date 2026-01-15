local menu = {}

function menu.load()
end

function menu.update(dt)
end

function menu.draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("Endless Runner", 320, 200)
  love.graphics.print("Press Enter/Space to Play", 280, 240)
end

return menu
