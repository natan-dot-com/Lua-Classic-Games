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
    love.window.setTitle('Pong Remake (with Lua)')
    
    -- RNG system
    math.randomseed(os.time())

    -- Set retro font
    mainFont = love.graphics.newFont('retro-gaming.ttf', 8)
    scoreFont = love.graphics.newFont('retro-gaming.ttf', 32)

    -- Set virtual window interface
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    SFX = {
        ['hit'] = love.audio.newSource('sfx/hit.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sfx/wall_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sfx/score.wav', 'static')
    }

    P1score = 0
    P2score = 0

    -- Set main instance game classes
    P1 = Paddle(10, 30, 5, 20)
    P2 = Paddle(VIRTUAL_WIDTH-10, VIRTUAL_HEIGHT-30, 5, 20)
    BallInstance = Ball(VIRTUAL_WIDTH/2 - 2, VIRTUAL_HEIGHT/2 - 2, 4, 4)

    -- Tracker of the current game state
    gameStateRunning = false
end

function love.update(dt)
    if gameStateRunning then
        -- Paddle-ball collision proccessing
        if BallInstance:collides(P1) then
            BallInstance.dx = -BallInstance.dx * 1.05
            BallInstance.x = P1.x + 5

            if BallInstance.dy < 0 then
                BallInstance.dy = -math.random(10, 150)
            else
                BallInstance.dy = math.random(10, 150)
            end

            SFX['hit']:play()
        end
        if BallInstance:collides(P2) then
            BallInstance.dx = -BallInstance.dx * 1.05
            BallInstance.x = P2.x - 4

            if BallInstance.dy < 0 then
                BallInstance.dy = -math.random(10, 150)
            else
                BallInstance.dy = math.random(10, 150)
            end

            SFX['hit']:play()
        end

        -- Ball-borders collision proccessing
        if BallInstance.y <= 0 then
            BallInstance.y = 0
            BallInstance.dy = -BallInstance.dy
            SFX['wall_hit']:play()
        end
        if BallInstance.y >= VIRTUAL_HEIGHT-4 then
            BallInstance.y = VIRTUAL_HEIGHT-4
            BallInstance.dy = -BallInstance.dy
            SFX['wall_hit']:play()
        end
    end

    -- Score system proccessing
    if BallInstance.x < 0 then
        P2score = P2score+1
        BallInstance:reset()
        gameStateRunning = not gameStateRunning
        SFX['score']:play()
    end
    if BallInstance.x > VIRTUAL_WIDTH then
        P1score = P1score+1
        BallInstance:reset()
        gameStateRunning = not gameStateRunning
        SFX['score']:play()
    end

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
    displayFPS()

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

function displayFPS()
    love.graphics.setFont(mainFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
