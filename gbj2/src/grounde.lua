grounde = {}


local function returnPeg(x,y)
    f = {}
    f.x = x 
    f.y = y 
    f.width = 64 
    f.height = 30
 
    return f
end
function grounde:load(modes,world)
    self.modes = modes
    self.world = world
    self.e_peg = returnPeg(256,412-30)
    self.m_peg = returnPeg(256,412-30)
end


function grounde:update(dt)
    
    if self.modes.easy == true then
       
    
    elseif self.modes.medium == true then
        
    elseif self.modes.hard == true then

    end

end


function grounde:draw()
    love.graphics.setColor(1,0,0)
    if self.modes.easy == true then
        love.graphics.rectangle("fill",self.e_peg.x,self.e_peg.y,self.e_peg.width,self.e_peg.height)
    elseif self.modes.medium == true then
        love.graphics.rectangle("fill",self.m_peg.x,self.m_peg.y,self.m_peg.width,self.m_peg.height)
    elseif self.modes.hard == true then
        
    end

end


return grounde