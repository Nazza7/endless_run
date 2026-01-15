local game_state = {
  current = "menu",
}

function game_state.set(state)
  game_state.current = state
end

function game_state.get()
  return game_state.current
end

return game_state
