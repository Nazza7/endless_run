local game_state = require("src.core.game_state")
local difficulty = require("src.game.difficulty")
local world = require("src.game.world")
local player = require("src.game.player")
local obstacles = require("src.game.obstacle_manager")
local coins = require("src.game.coin_manager")
local police = require("src.game.police")
local score = require("src.game.score")
local hud = require("src.ui.hud")
local menu = require("src.ui.menu")
local gameover = require("src.ui.gameover")

local function reset_run()
  difficulty.reset()
  world.reset()
  player.reset()
  obstacles.reset()
  coins.reset()
  police.reset()
  score.reset()
end

function love.load()
  game_state.set("menu")
  difficulty.load()
  world.load()
  player.load()
  obstacles.load()
  coins.load()
  police.load()
  score.load()
  hud.load()
  menu.load()
  gameover.load()
end

function love.update(dt)
  local state = game_state.get()
  if state == "menu" then
    menu.update(dt)
    return
  end

  if state == "gameover" then
    gameover.update(dt)
    return
  end

  difficulty.update(dt)
  world.update(dt)
  player.update(dt)
  obstacles.update(dt, difficulty.get_speed())
  coins.update(dt, difficulty.get_speed())
  police.update(dt)

  score.update(dt, difficulty.get_speed())

  if obstacles.check_collision(player.get_hitbox()) then
    if police.on_obstacle_hit() then
      game_state.set("gameover")
    end
  end

  if coins.check_collision(player.get_hitbox()) then
    score.add_coin()
  end
end

function love.draw()
  local state = game_state.get()

  if state == "menu" then
    menu.draw()
    return
  end

  world.draw()
  obstacles.draw()
  coins.draw()
  player.draw()
  police.draw()
  hud.draw(score.get_points(), score.get_coins(), police.is_danger())

  if state == "gameover" then
    gameover.draw(score.get_points())
  end
end

function love.keypressed(key)
  local state = game_state.get()

  if state == "menu" then
    if key == "return" or key == "space" then
      reset_run()
      game_state.set("game")
    end
    return
  end

  if state == "gameover" then
    if key == "return" or key == "space" then
      reset_run()
      game_state.set("game")
    end
    return
  end

  player.handle_input(key)
end
