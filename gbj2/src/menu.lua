menu = {}

local play_btn = {x=256-70,y=256,width=150,height=50}
local quit_btn = {x=256-70,y=356,width=150,height=50}
--font
local function load_font(size)
    d = love.graphics.newFont("fonts/pixel.ttf",size)
    return d
end

local function draw_font(f,r,g,b,t,x,y)
    love.graphics.setFont(f)
    love.graphics.setColor(r,g,b)
    love.graphics.print(t,x,y)
end
--end
local function draw_button(t,btn,x,y)
    love.graphics.setColor(1,1,1)
    love.graphics.draw(btn.img,btn.x,btn.y)
    draw_font(load_font(15),1,1,1,t,x,y)
end

local function col(a)
    if math.abs(love.mouse.getX() - (a.x + a.width / 2 )) < a.width / 2 and math.abs(love.mouse.getY() - (a.y + a.height / 2)) < a.height / 2 then
        return true
    else
        return false
    end
end

function menu:load(game_state)
    self.game_state = game_state
    play_btn.img = love.graphics.newImage("assets/button.png")
    quit_btn.img = love.graphics.newImage("assets/button.png")
end


function menu:update(dt)
    if love.mouse.isDown(1) then
        if col(play_btn) then
            self.game_state.menu = false
            self.game_state.game = true
        end
        
        if col(quit_btn) then
            love.event.quit()
        end
    end
end

function menu:draw()
    draw_button("play",play_btn,235,261)
    draw_button("quit",quit_btn,235,361)
    draw_font(load_font(30),1,1,1,"Gameboom Jump!",15,30)
 
end











return menu