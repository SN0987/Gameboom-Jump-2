player = {}


local count_idle = 1
local count_walk = 1
local count_jump = 1
local left_particles = {}
local right_particles = {}
local is_particle_left = false
local is_particle_right = false


local function load_jumps()
    d = love.filesystem.read("jumps.txt")

    return d
end


function player:load(world)
    self.world = world
    self.animationState = {idle=true,jump=false,run=false}
    self.run_imgs = {love.graphics.newImage("assets/walk1.png"),love.graphics.newImage("assets/walk2.png"),love.graphics.newImage("assets/walk3.png"),love.graphics.newImage("assets/walk4.png"),love.graphics.newImage("assets/walk5.png"),love.graphics.newImage("assets/walk6.png")}
    self.idle_imgs = {love.graphics.newImage("assets/idle1.png"),love.graphics.newImage("assets/idle2.png"),love.graphics.newImage("assets/idle4.png"),love.graphics.newImage("assets/idle4.png"),love.graphics.newImage("assets/idle5.png"),love.graphics.newImage("assets/idle6.png")}
    self.jump_imgs = {love.graphics.newImage("assets/jump1.png"),love.graphics.newImage("assets/jump2.png"),love.graphics.newImage("assets/jump3.png"),love.graphics.newImage("assets/jump4.png"),love.graphics.newImage("assets/jump5.png"),love.graphics.newImage("assets/jump6.png"),love.graphics.newImage("assets/jump7.png"),love.graphics.newImage("assets/jump8.png"),love.graphics.newImage("assets/jump9.png"),love.graphics.newImage("assets/jump10.png"),love.graphics.newImage("assets/jump11.png"),love.graphics.newImage("assets/jump12.png"),love.graphics.newImage("assets/jump13.png")}
    self.collider = self.world:newRectangleCollider(256,200,38,64)
    self.collider:setCollisionClass("Player")
    self.width = 38
    self.height = 64
    self.x,self.y = self.collider:getPosition()
    self.is_left = false
    self.is_right = false
    self.is_jump = false
    self.is_touch = true
    self.jumps = {}
    if not love.filesystem.getInfo("jumps.txt") then
        self.jumps.j = 0
    elseif love.filesystem.getInfo("jumps.txt") then
        self.jumps.j = load_jumps()
    end
    
    
end


local function player_movement(pl)
    local vx,vy = pl.collider:getLinearVelocity()
    if pl.is_left == true and vx > -600 then
        pl.collider:applyForce(-5000,0)
        pl.animationState.idle = false
        pl.animationState.jump = false
        pl.animationState.run = true
    elseif pl.is_right == true and vx < 600 then
        pl.collider:applyForce(5000,0)
        pl.animationState.idle = false
        pl.animationState.jump = false
        pl.animationState.run = true
    elseif pl.is_right == false and pl.is_left == false then
        pl.animationState.idle = true
        pl.animationState.jump = false
        pl.animationState.run = false
    end
    if pl.is_jump == true then
        pl.animationState.idle = false
        pl.animationState.jump = true
        pl.animationState.run = false
        
    end
    if pl.collider:enter("Ground") then
        pl.is_touch = true
    end
    

end

local function particles(player,is_particle_left,is_particle_right,left_particles,right_particles)
    if is_particle_left == true then
        table.insert(left_particles,{x=player.x + 60,y=player.y,width=6,height=6})
    
    elseif is_particle_right == true then
        table.insert(right_particles,{x=player.x - 60,y=player.y,width=6,height=6})

    end

    if is_particle_left == false then
        for i=0,table.getn(left_particles) do
            table.remove(left_particles,i)
        end

    elseif is_particle_right == false then
        for i = 0, table.getn(right_particles) do
            table.remove(right_particles,i)
        end
    end
end


local function render_particles(player,is_particle_left,is_particle_right,left_particles,right_particles)
    love.graphics.setColor(0.2,0.3,0.8)
    if is_particle_left == true then
        for i,p in pairs(left_particles) do 
            love.graphics.rectangle("fill",p.x,p.y,p.width,p.height)
        end

    elseif is_particle_right == true then
        for i,p in pairs(right_particles) do
            love.graphics.rectangle("fill",p.x,p.y,p.width,p.height)
        end
    end

end

function player:update(dt)
    self.x,self.y = self.collider:getPosition()

    if self.animationState.idle == true then

        count_idle = count_idle + 5 * dt
        if count_idle >= table.getn(self.idle_imgs) then
            count_idle = 1
        end
    elseif self.animationState.run == true then
        count_walk = count_walk + 12 * dt
        if count_walk >= table.getn(self.run_imgs) then
            count_walk = 1
        end
    elseif self.animationState.jump == true then
        count_jump = count_jump + 8 * dt
        if count_jump >= table.getn(self.jump_imgs) then
            count_jump = 1
        end
    end
    player_movement(self)
    particles(player,is_particle_left,is_particle_right,left_particles,right_particles)
end

function player:draw()
    love.graphics.setColor(1,1,1)
    if self.animationState.idle == true then
        love.graphics.draw(self.idle_imgs[math.floor(count_idle)],self.x-20,self.y-30)
    elseif self.animationState.run == true then
        love.graphics.draw(self.run_imgs[math.floor(count_walk)],self.x-20,self.y-30)
    
    elseif self.animationState.jump == true then
        love.graphics.draw(self.jump_imgs[math.floor(count_jump)],self.x-20,self.y-30)
    end

    render_particles(player,is_particle_left,is_particle_right,left_particles,right_particles)
end

function love.keypressed(key)
    if key == "a" then
        player.is_left = true
        is_particle_left = true
    elseif key == "d" then
        player.is_right = true
        is_particle_right = true
    end

    if key == "space" and player.is_touch == true then
        player.collider:applyLinearImpulse(0,-2500)
    

        player.is_jump = true
        
        player.is_touch = false
        player.jumps.j = player.jumps.j + 1
        love.filesystem.write("jumps.txt",player.jumps.j)
        
    end
end

function love.keyreleased(key)
    if key == "a" then
        player.is_left = false
        is_particle_left = false
    elseif key == "d" then
        player.is_right = false
        is_particle_right = false
    end
    if key == "space" then
        player.is_jump = false
    end
end
return player