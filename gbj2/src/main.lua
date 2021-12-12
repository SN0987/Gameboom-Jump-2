require "menu"
require "game"

local game_state = {menu=true,game=false}

function love.load()
    menu:load(game_state)
    game:load(game_state)

end


function love.update(dt)
    if game_state.menu == true then
        menu:update(dt)
    elseif game_state.game == true then
        game:update(dt)
        

    end

end

function love.draw()
    if game_state.menu == true then
        menu:draw()
    elseif game_state.game == true then
        game:draw()
    end

end