--[[
  Flappy Bird
  Auteur: @devalnor
  Date: 2023-12-7
  Licence: MIT
]]--

p = require('paxolib')

--- Configuration ---
maxFps = 5 -- Nombre de frames par seconde max
gravity = 7 -- Gravité du jeu
scrollingSpeed = 10 -- Vitesse de défilement du jeu
birdJump = 5 -- Force du saut du bird
marginHack = -16 -- Hack qui fixe la marge de la fenêtre, remettre à 0 quand ce sera fixé dans paxos
---

running = false
incY = gravity
initialPosX = 50
initialPosY = 170
birdX = initialPosX
birdY = initialPosY
cameraX = 0
frameX = 0
frameY = 50
limitX = 285
limitY = 350
pipeSpacing = 180

-- Class Pipe --
Pipe = {}
Pipe.__index = Pipe

function Pipe:new(x, height, gap)
    local obj = {
        x = x,
        height = height,
        width = 52, -- Largeur fixe du tuyau
        gap = gap, -- Espace entre les tuyaux haut et bas
        sprite = p.image(window, "pipe-green.png", x, height, 52, 320)
    }
    setmetatable(obj, Pipe)
    return obj
end

function Pipe:update(cameraX)
  if (self.x+self.width-marginHack+1 > cameraX and self.x < cameraX+limitX-marginHack) then
    self.sprite:setX(self.x - cameraX)
  elseif (self.x ~=-100) then
    -- cache le sprite quand il n'est pas dans la partie visible de l'écran
    self.sprite:setX(-100)
  end
end

-- Loop --
function update()
  score:setText( 'Score: ' .. tostring(math.floor(cameraX/30)))
  
  if running then
    birdY = birdY + incY;
    cameraX=cameraX+scrollingSpeed;

    if (incY < gravity) then
      incY = incY + math.ceil(gravity/10)
    end

    if (birdY < frameY-50 or birdY > frameY+limitY-10) then
      die()
    end

    bird:setY(math.floor((birdY)))
    base:setX(-(cameraX % 24)-32-24)

    for i, pipe in ipairs(pipes) do
      pipe:update(cameraX)
      if checkCollision(pipe) then
        die()
      end
    end  
  end
end


function start()
  birdX=initialPosX
  birdY=initialPosY
  cameraX=0
  bird:setX(initialPosX)
  
  running = true
  buttonRun:setText("Jump")
end

function die()
  running = false
  bird:setX(-200)
  buttonRun:setText("Try again")
end

function checkCollision(pipe)
  local posX = birdX + cameraX
  local posY = birdY
  return posX < pipe.x + pipe.width and posX + 34 > pipe.x and
         (posY > pipe.height)
end

-- Main
function run()
  window = p.window("Flappy Bird")
  local bg = p.image(window, "background-day.png", frameX, frameY, 320, 512)
  bg:setY(-38)
  bg:setX(marginHack)

  score  = p.label(window,170, 20, 140, 30)
  score:setFontSize(16)
  bird = p.image(window, "yellowbird-upflap.png", birdX, birdY, 34, 24)
  
  pipes = {}
  
  local initialX = 220 -- Position x initiale pour le premier tuyau

  for i = 1, 20 do
    table.insert(pipes, Pipe:new(initialX + (i - 1) * pipeSpacing,  math.random(200,300+i*2) - (i*5), 200))
  end

  base = p.image(window, "base-long.png", 100, 374, 673, 100)
  base:setX(marginHack*2)
  buttonRun = p.button(window,0, 420,280, 42)
  buttonRun:setText("Start")

  buttonRun:onClick(function() 
    if not running then
      start()
      return
    else 
      incY= -birdJump
      return
    end
  end)
  local updateInterval = math.ceil(1000 / maxFps)

  p.setInterval(function() update() end, updateInterval)
  p.setWindow(window)
end