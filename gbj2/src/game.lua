require "easy"
require "stats"
require "credits"
game = {}

local modes = {easy=false,credit=false,stats=false}

local hard_btn = {x=230,y=180,width=64,height=64,click="not"}

local stat_btn = {x=50,y=180,width=64,height=64,click="not"}

local credit_btn = {x=400,y=180,width=64,height=64,click="not"}

local back_arrow = {x=10,y=512-30,width=30,height=30,click="not"}


local function load_font(size)
    d = love.graphics.newFont("fonts/pixel.ttf",size)
    return d
end

local function draw_font(f,r,g,b,t,x,y)
    love.graphics.setFont(f)
    love.graphics.setColor(r,g,b)
    love.graphics.print(t,x,y)
end

local function col(a)
    if math.abs(love.mouse.getX() - (a.x + a.width / 2)) < a.width / 2 and math.abs(love.mouse.getY() - (a.y + a.height / 2)) < a.height / 2 then
        return true
    else
        return false
    end
end

local function make_button(t,x,y,btn)
    if btn.click == "yes" then
        draw_font(load_font(20),1,1,1,t,x,y)
    end

    love.graphics.draw(btn.img,btn.x,btn.y)
end


function game:load(game_state)
    self.game_state = game_state
    hard_btn.img = love.graphics.newImage("assets/hb3.png")
    stat_btn.img = love.graphics.newImage("assets/eb2.png")
    credit_btn.img = love.graphics.newImage("assets/mb2.png")
    back_arrow.img = love.graphics.newImage("assets/arrow_one.png")
    easy:load(modes)
    stats:load(easy.jumps,easy.score,modes)
    credits:load(modes)
end

local function update_state_handler(modes,back_arrow,game_state,easy_btn,dt)
    if modes.easy == false and modes.credit == false and modes.stats == false then
        if love.mouse.isDown(1) then
            if col(back_arrow) then
                game_state.game = false
                game_state.menu = true
            end
            if col(hard_btn) then
                modes.easy = true
                modes.credit = false
                modes.stats = false
            end
            if col(credit_btn) then
                modes.easy = false
                modes.credit = true
                modes.stats = false
            end
            if col(stat_btn) then
                modes.easy = false
                modes.credit = false
                modes.stats = true
            end
        end
    end
end

local function check_update(modes,easy,credits,stats,dt)
    if modes.easy == true then
        easy:update(dt)
    elseif modes.credit == true then
        credits:update(dt)

    elseif modes.stats == true then
        stats:update(dt)
    end
end
function game:update(dt)
    update_state_handler(modes,back_arrow,self.game_state,easy_btn,dt)
    check_update(modes,easy,credits,stats,dt)
end

local function draw_state_handler(modes)
    if modes.easy == true then
        easy:draw()
    elseif modes.credit == true then
        credits:draw()

    elseif modes.stats == true then
        stats:draw()
    end
end

local function button_handler(hard_btn,back_arrow)
    if col(hard_btn) then
        hard_btn.click = "yes"
    else
        hard_btn.click = "not"
    end
    
    if col(back_arrow) then
        back_arrow.click = "yes"
    else
        back_arrow.click = "not"
    end

    if col(stat_btn) then
        stat_btn.click = "yes"

    else
        stat_btn.click = "not"
    end

    if col(credit_btn) then
        credit_btn.click = "yes"

    else
        credit_btn.click = "not"
    end
end
local function add_button(hard_btn,back_arrow)
    make_button("Play",260,330,hard_btn)
    make_button("Back",260,330,back_arrow)
    make_button("stats",260,330,stat_btn)
    make_button("credits",260,330,credit_btn)
end
function game:draw()
    if modes.easy == false and modes.credit == false and modes.stats == false then
        love.graphics.setColor(1,1,1)
        draw_font(load_font(20),1,1,1,"Mode: ", 120,330)
        love.graphics.line(120,380,390,380)
        add_button(hard_btn,back_arrow)
        button_handler(hard_btn,back_arrow)
    end
    draw_state_handler(modes)

end





return game