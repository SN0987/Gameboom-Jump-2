enemy = {}
Timer = require "library/timer"
local function spike(x,y)
    s = {}
    s.x = x
    s.y = y
    s.width = 32
    s.height = 16
    s.trail = {}
    
    return s
end
function enemy:load(world,modes)
    self.modes = modes
    self.world = world
    self.e_spike = spike(math.random(0,512),0)
    self.e_spike_2 = spike(math.random(0,512),0)
    self.e_spike.img = love.graphics.newImage("assets/spike.png")
    self.e_spike_2.img = love.graphics.newImage("assets/spike.png")
end

local function spike_movement(spike,sy,dt)
    local speedy = sy
    spike.y = spike.y + speedy * dt
    if spike.y >= love.graphics.getHeight() then
        spike.y = 0
        spike.x = math.random(0,512)
    end
end
local function clear_trail(spike)
    if table.getn(spike.trail) >= 10 then
        for i=0,table.getn(spike.trail) do
            table.remove(spike.trail,i)
        end
    end

end
function enemy:update(dt)
    if self.modes.easy == true then
        spike_movement(self.e_spike,500,dt)
        table.insert(self.e_spike.trail,{x=self.e_spike.x + 15,y=self.e_spike.y - 10,width=2,height=5})
        clear_trail(self.e_spike)
        spike_movement(self.e_spike_2,650,dt)
        table.insert(self.e_spike_2.trail,{x=self.e_spike_2.x + 15,y=self.e_spike_2.y - 10,width=2,height=5})
        clear_trail(self.e_spike_2)
        
    end
   

end

local function draw_trail(spike)
    love.graphics.setColor(0.7,0.1,0.1)
    for i, p in pairs(spike.trail) do
        love.graphics.rectangle("fill",p.x,p.y,p.width,p.height)
    end
end
function enemy:draw()
    love.graphics.setColor(1,1,1)
    if self.modes.easy == true then
        love.graphics.draw(self.e_spike.img,self.e_spike.x,self.e_spike.y)
        draw_trail(self.e_spike)
        love.graphics.draw(self.e_spike.img,self.e_spike_2.x,self.e_spike_2.y)
        draw_trail(self.e_spike_2)
    end
        
    
end







return enemy