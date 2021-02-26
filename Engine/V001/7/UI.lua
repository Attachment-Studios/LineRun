-- UI.lua

require 'system'

ui = {}
ui.objectColor = {255/255, 142/255, 4/255, 255/255}
ui.image = love.graphics.newImage('LineRun.png')
ui.font = love.graphics.newFont('font.ttf', 20)
ui.h1font = love.graphics.newFont('font.ttf', 50)

function ui.background()
    love.graphics.setColor(ui.objectColor)
    love.graphics.polygon('fill', 20, -100, love.graphics.getWidth()/3, love.graphics.getHeight()+10, -100, love.graphics.getHeight()+10, -20, -100)
    love.graphics.setBackgroundColor(1, 1, 1, 1)
end

function ui.objects()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(ui.image, love.graphics.getWidth()-220, 20, 0, 0.5, 0.5)
    love.graphics.setColor(37/255, 37/255, 37/255, 1)
    love.graphics.setFont(ui.font)
    love.graphics.print(system.version, love.graphics.getWidth()-ui.font:getWidth(system.version)-25, 90)
    love.graphics.setFont(ui.h1font)
    love.graphics.print('Please Drop A ".linecode" File', love.graphics.getWidth()/2-ui.h1font:getWidth('Please Drop A ".linecode" File')/2, love.graphics.getHeight()/2-ui.h1font:getHeight('Please Drop A ".linecode" File')/2)
end

function ui.draw()
    ui.background()
    ui.objects()
end
