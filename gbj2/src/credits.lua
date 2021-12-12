credits = {}


local function load_font(size)
    d = love.graphics.newFont("fonts/pixel.ttf")
    return d
end

local function draw_font(f,r,g,b,t,x,y)
    love.graphics.setColor(r,g,b)
    love.graphics.setFont(f)
    love.graphics.print(t,x,y)
end
function credits:load(modes)
    self.modes = modes

end

local function backIt(modes,key)
    if love.keyboard.isDown(key) then
        modes.credit = false
        modes.stats = false
        modes.easy = false
    end

end

function credits:update(dt)
    
    backIt(self.modes,"q")
    backIt(self.modes,"backspace")
end

function credits:draw()
    draw_font(load_font(20),0.8,0.2,0.2,"By Sohaab Naeem",256-100,256)
end