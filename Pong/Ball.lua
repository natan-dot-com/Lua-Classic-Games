local class = require 'modules/oops'

Ball = class {
    __init = function(self, x, y, width, height)
        self.x = x
        self.y = y
        self.width = width
        self.height = height

        self.dy = math.random(2) == 1 and -100 or 100
        self.dx = math.random(-50, 50) * 1.5
    end,

    -- Reset ball's position to the starting one
    reset = function(self)
        self.x = VIRTUAL_WIDTH/2 - 2
        self.y = VIRTUAL_HEIGHT/2 - 2

        self.dy = math.random(2) == 1 and -100 or 100
        self.dx = math.random(-50, 50) * 1.5
    end,

    -- Update ball's current position
    update = function(self, dt)
        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt
    end,

    -- On-screen rendering of the ball
    render = function(self)
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    end,

    -- Collision check by AABB method
    collides = function(self, Paddle)
        if self.x > Paddle.x + Paddle.width or Paddle.x > self.x + self.width then
            return false
        end

        if self.y > Paddle.y + Paddle.height or Paddle.y > self.y + self.height then
            return false
        end

        return true
    end
}


