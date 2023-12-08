p = require('paxolib')

running = false
speed= 1
incX = speed
incY = speed
posX = 0
posY = 50

frameX = 0
frameY = 50
limitX = 285
limitY = 340

function update()
  if running then
    posX = posX + incX;
    posY = posY + incY;
    if (posX < frameX or posX > frameX+limitX-10) then
      ball:setColor(math.random(0,0xFFFFFF))
      incX = -incX
    end
    if (posY < frameY or posY > frameY+limitY-10) then
      ball:setColor(math.random(0,0xFFFFFF))
      incY = -incY
    end
    ball:setX(posX)
    ball:setY(posY)
 
  end
  label:setText(tostring(posX) .. "x" ..  tostring(posY))
end



function run()
  local window = p.window("Breakout")
  local frame = p.box(window, frameX, frameY, limitX, limitY)
  ball = p.box(window, posX, posY, 10, 10)

  label  = p.label(window,0, 20, 200, 30)

  local buttonRun = p.button(window,0, 410,280, 42)
  frame:setColor(0xFFF)

  ball:setColor(p.COLOR_SUCCESS)


  --label:setHorizontalAlignment(1)
  buttonRun:setText("Start")
  --print(tostring(p.COLOR_LIGHT))
  
  buttonRun:onClick(function() 
    if running then
      running = false
      buttonRun:setText("Start")
      return
    else 
      running = true
      chrono = p.monotonic()
      buttonRun:setText("Stop")
    end
  end)

  p.setInterval(function() update() end, 10)

  p.setWindow(window)
end