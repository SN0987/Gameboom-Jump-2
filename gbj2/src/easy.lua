
require "player"
require "enemy"
require "grounde"
easy = {}
local walls = {}
local score = {}


local function returnGround()
    ground = {}
    ground.collider = world:newRectangleCollider(0,412,512,100)
    ground.collider:setType("static")
    ground.px,ground.py = ground.collider:getPosition()
    
    return ground
end

local function returnBg()
    bg = {}
    bg.x = 0
    bg.y = 0
    return bg
end

local function returnWall(type,world)
    wall = {}
    if type == "left" then
        wall.collider = world:newRectangleCollider(0,0,1,512)
        wall.collider:setType("static")
    elseif type == "right" then
        wall.collider = world:newRectangleCollider(512,0,1,512)
        wall.collider:setType("static")
    elseif type == "up" then
        wall.collider = world:newRectangleCollider(0,0,512,1)
        wall.collider:setType("static")

    end

    return wall
end
local function load_score()
    d = love.filesystem.read("easy_s.txt")
    return d
end

--fonts
local function load_font(size)
    d = love.graphics.newFont("fonts/pixel.ttf")
    return d
end

local function draw_font(f,r,g,b,t,x,y)
    love.graphics.setFont(f)
    love.graphics.setColor(r,g,b)
    love.graphics.print(t,x,y)
end
--end
local function col(a,b)
    if math.abs(b.x - (a.x + a.width / 2 )) < a.width / 2 and math.abs(b.y - (a.y + a.height / 2)) < a.height / 2 then
        return true
    else
        return false
    end

end

function load_walls(world)
    w = {}
    w.left_wall = returnWall("left",world)
    w.right_wall = returnWall("right",world)
    w.up_wall = returnWall("up",world)
    w.left_wall.collider:setCollisionClass("left-wall")
    w.right_wall.collider:setCollisionClass("right-wall")
    return w

end
local function loads(player,enemy,grounde,modes,world)
    player:load(world)
    enemy:load(world,modes)
    grounde:load(modes,world)
end

function easy:load(modes,game_state)
    wf = require("library/windfield")
    self.modes = modes
    self.game_state = game_state
    world = wf.newWorld(0,650)
    world:addCollisionClass("Ground")
    world:addCollisionClass("Player")
    world:addCollisionClass("left-wall")
    world:addCollisionClass("right-wall")
    ground = returnGround()
    ground.collider:setCollisionClass("Ground")
    ground.img = love.graphics.newImage("assets/floor_remade.png")
    bg = returnBg()
    bg.img = love.graphics.newImage("assets/Smile_bg.png")
    walls = load_walls(world)
    if not love.filesystem.getInfo("easy_s.txt") then
        score.hs = 0
    elseif love.filesystem.getInfo("easy_s.txt") then
        score.hs = load_score()
    end
    score.points = 0
    loads(player,enemy,grounde,self.modes,world)
    self.score = score
    self.jumps = player.jumps
 
end
local function collisions(player,spike1,spike2,score,grounde)
    if col(player,spike1) then
       score.points = 0
       love.filesystem.write("easy_s.txt",score.hs)
    elseif col(player,grounde.e_peg) then
        score.points = 0
        love.filesystem.write("easy_s.txt",score.hs)

    end
    if col(player,spike2) then
        score.points = 0
        love.filesystem.write("easy_s.txt",score.hs)
    end

    if player.collider:enter("left-wall") then
        player.collider:applyLinearImpulse(2000,0)
    elseif player.collider:enter("right-wall") then
        player.collider:applyLinearImpulse(-2000,0)
    end

end
local function backFromMode(modes,key)
    if love.keyboard.isDown(key) then
        modes.easy = false
        modes.hard = false
        modes.medium = false
    end
end

local function updates(player,enemy,grounde,world,dt)
    enemy:update(dt)
    grounde:update(dt)
    player:update(dt)
    world:update(dt)

end
function easy:update(dt)
    
    backFromMode(self.modes,"q")
    backFromMode(self.modes,"backspace")
    updates(player,enemy,grounde,world,dt)
    
    score.points = score.points + 1 * dt
    if score.points > tonumber(score.hs) then
        score.hs = score.points
    end
    collisions(player,enemy.e_spike,enemy.e_spike_2,score,grounde)
   
end

local function draws(player,grounde,enemy)
    grounde:draw()
    enemy:draw()
    player:draw()
end
function easy:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.draw(bg.img,bg.x,bg.y)
    love.graphics.draw(ground.img,0,412)
    draw_font(load_font(15),0.2,0.5,1,"Score " .. tostring(math.floor(score.points)),0,0)
    draws(player,grounde,enemy)
end







return easy