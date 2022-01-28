local class = require 'modules/oops'

Paddle = class {
    __init = function(self, x, y, width, height)
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.dy = 0
    end,

    update = function(self, dt)
        if self.dy < 0 then
            self.y = math.max(0, self.y + self.dy * dt)
        else
            self.y = math.min(VIRTUAL_HEIGHT-self.height, self.y + self.dy * dt)
        end
    end,

    render = function(self)
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    end
}
