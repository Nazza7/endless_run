local game_state = {
  current = "menu",
}

local valid_states = {
  menu = true,
  game = true,
  gameover = true,
}

function game_state.set(state)
  if not valid_states[state] then
    return
  end
  game_state.current = state
end

function game_state.get()
  return game_state.current
end

function game_state.is_menu()
  return game_state.current == "menu"
end

function game_state.is_game()
  return game_state.current == "game"
end

function game_state.is_gameover()
  return game_state.current == "gameover"
end

return game_state
