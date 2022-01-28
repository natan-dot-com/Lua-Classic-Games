local class = require 'modules/oops'

Ball = class {
    __init = function (self, x, y, width, height)
        self.x = x
        self.y = y
        self.width = width
        self.height = height

        self.dy = math.random(2) == 1 and -100 or 100
        self.dx = math.random(-50, 50) * 1.5
    end,

    reset = function (self)
        self.x = VIRTUAL_WIDTH/2 - 2
        self.y = VIRTUAL_HEIGHT/2 - 2

        self.dy = math.random(2) == 1 and -100 or 100
        self.dx = math.random(-50, 50) * 1.5
    end,

    update = function (self, dt)
        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt
    end,

    render = function (self)
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    end
}


