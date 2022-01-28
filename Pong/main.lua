push = require 'modules/push'
class = require 'modules/oops'
require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    -- Set retro filter (not smooth)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- RNG system
    math.randomseed(os.time())

    -- Set retro font
    mainFont = love.graphics.newFont('retro-gaming.ttf', 8)
    scoreFont = love.graphics.newFont('retro-gaming.ttf', 30)

    -- Set virtual window interface
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    P1score = 0
    P2score = 0

    -- Set main instance game classes
    P1 = Paddle(10, 30, 5, 20)
    P2 = Paddle(VIRTUAL_WIDTH-10, VIRTUAL_HEIGHT-30, 5, 20)
    BallInstance = Ball(VIRTUAL_WIDTH/2 - 2, VIRTUAL_HEIGHT/2 - 2, 4, 4)

    -- Tracker if the game is running or not
    gameStateRunning = false
end

function love.update(dt)
    -- First paddle control keys
    if love.keyboard.isDown('w') then
        P1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        P1.dy = PADDLE_SPEED
    else 
        P1.dy = 0
    end

    -- Second paddle control keys
    if love.keyboard.isDown('up') then
        P2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        P2.dy = PADDLE_SPEED
    else 
        P2.dy = 0
    end

    if gameStateRunning then
        BallInstance:update(dt)
    end
    P1:update(dt)
    P2:update(dt)
end

function love.draw()
    -- Draw in current virtual resolution
    push:apply('start')

    -- Define background color (RGB = [40, 45, 52])
    --love.graphics.clear(30, 30, 30, 255)
    love.graphics.setFont(mainFont)
    love.graphics.printf('Pong Remake (w/ Lua)', 0, 20, VIRTUAL_WIDTH, 'center')

    -- Draw scoreboard
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(P1score), VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(P2score), VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGHT/3)

    -- Draw first paddle
    P1:render()
    -- Draw second paddle
    P2:render()
    -- Draw centered ball
    BallInstance:render()

    push:apply('end')
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()

    -- Set/reset game
    elseif key == 'enter' or key == 'return' then
        if gameStateRunning then
            BallInstance:reset()
        end
        gameStateRunning = not gameStateRunning
    end
end

