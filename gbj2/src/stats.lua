stats = {}


local function load_font(size)
    d = love.graphics.newFont("fonts/pixel.ttf")
    return d
end
local function draw_font(f,r,g,b,t,x,y)
    love.graphics.setColor(r,g,b)
    love.graphics.setFont(f)
    love.graphics.print(t,x,y)
end
function stats:load(jumps,score,modes)
    self.modes = modes
    self.score = score
    self.jumps = jumps
 
end

local function backIt(modes,key)
    if love.keyboard.isDown(key) then
        modes.credit = false
        modes.stats = false
        modes.easy = false
    end

end
function stats:update(dt)
    backIt(self.modes,"q")
    backIt(self.modes,"backspace")



end


function stats:draw()
    draw_font(load_font(20),0.8,0.2,0.2,"Highscore " .. tostring(math.floor(self.score.hs)),256-70,256)
    draw_font(load_font(20),0.8,0.2,0.2,"Jumps " .. tostring(math.floor(self.jumps.j)),256-50,256+100)

end




return stats