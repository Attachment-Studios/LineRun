-- UI.lua

require 'system'
require(system.vcode..'.CI')
require(system.vcode..'.is')

ui = {}
ui.bgcolor = {0.9, 0.9, 0.9, 1}
ui.backgroundObjectColor = {1, 0.55, 0.01, 1}
ui.image = love.graphics.newImage('LineRun.png')
ui.font = love.graphics.newFont('font.ttf', 20)
ui.h1font = love.graphics.newFont('font.ttf', 50)
ui.objectColor = {0.15, 0.15, 0.15}

ui.linepackCode = [[
ui.bgc(0.9, 0.9, 0.9, 1)
ui.bgoc(1, 0.55, 0.01, 1)
ui.oc(0.15, 0.15, 0.15)
]]

ui.linepackCodeTable = {}
if not(love.filesystem.getInfo('ui.linepack')) then
    love.filesystem.write('ui.linepack', ui.linepackCode)
end
if love.filesystem.getInfo('ui.linepack') then
    for line in love.filesystem.lines('ui.linepack') do
        table.insert(ui.linepackCodeTable, line)
    end
end
for i = 1, #ui.linepackCodeTable do
    ui.linepackCodeTable[i] = is.comment(ui.linepackCodeTable[i])
    local module = is.module(ui.linepackCodeTable[i])
    local fragment = is.moduleFragment(ui.linepackCodeTable[i])
    if module == 'ui' then
        if fragment == 'bgc' then
            local r, g, b, a = is.argument(ui.linepackCodeTable[i])
            ui.bgcolor = {r, g, b, a}
        elseif fragment == 'bgoc' then
            local r, g, b, a = is.argument(ui.linepackCodeTable[i])
            ui.backgroundObjectColor = {r, g, b, a}
        elseif fragment == 'oc' then
            local r, g, b, a = is.argument(ui.linepackCodeTable[i])
            ui.objectColor = {r, g, b, a}
        elseif fragment == "reset" then
            love.filesystem.remove("ui.linepack")
        else
            print('ui graphic loading("ui.linepack", native-file): error in line '..i..":")
            print('    Unknown fragment "'..fragment..'"')
            print('    Suggestion: Try dropping a new file to restore older ui or make a working one')
        end
    end
end
function ui.actionCheck(command, line)
    local module = is.module(command)
    local fragment = is.moduleFragment(command)
    if module == 'ui' then
        if fragment == 'bgc' then
            local r, g, b, a = is.argument(command)
            ui.bgcolor = {r, g, b, a}
        elseif fragment == 'bgoc' then
            local r, g, b, a = is.argument(command)
            ui.backgroundObjectColor = {r, g, b, a}
        elseif fragment == 'oc' then
            local r, g, b, a = is.argument(command)
            ui.objectColor = {r, g, b, a}
        else
            print('error in line '..line..":")
            print('    Unknown fragment "'..fragment..'"')
        end
    end
end

function ui.background()
    love.graphics.setColor(tonumber(ui.backgroundObjectColor[1]), tonumber(ui.backgroundObjectColor[2]), tonumber(ui.backgroundObjectColor[3]), tonumber(ui.backgroundObjectColor[4]))
    love.graphics.polygon('fill', 20, -100, love.graphics.getWidth()/3, love.graphics.getHeight()+10, -100, love.graphics.getHeight()+10, -20, -100)
    love.graphics.setBackgroundColor(tonumber(ui.bgcolor[1]), tonumber(ui.bgcolor[2]), tonumber(ui.bgcolor[3]), tonumber(ui.bgcolor[4]))
    love.graphics.draw(ui.image, love.graphics.getWidth()-220, 20, 0, 0.5, 0.5)
end

function ui.objects()
    love.graphics.setColor(tonumber(ui.objectColor[1]), tonumber(ui.objectColor[2]), tonumber(ui.objectColor[3]), 1)
    love.graphics.setFont(ui.font)
    love.graphics.print(system.version, love.graphics.getWidth()-ui.font:getWidth(system.version)-25, 90)
    love.graphics.setFont(ui.h1font)
    love.graphics.print('Please Drop A ".linecode" File', love.graphics.getWidth()/2-ui.h1font:getWidth('Please Drop A ".linecode" File')/2, love.graphics.getHeight()/2-ui.h1font:getHeight('Please Drop A ".linecode" File')/2)
    if system.editerActive then
        love.graphics.setColor(tonumber(ui.objectColor[1]), tonumber(ui.objectColor[2]), tonumber(ui.objectColor[3]), 1)
    else
        love.graphics.setColor(tonumber(ui.objectColor[1]), tonumber(ui.objectColor[2]), tonumber(ui.objectColor[3]), 0)
    end
    love.graphics.setFont(ui.font)
    love.graphics.print('Editor Connected', 5, 5)
end

function ui.draw()
    ui.background()
    ui.objects()
end