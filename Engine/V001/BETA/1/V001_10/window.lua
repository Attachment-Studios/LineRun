-- window.lua

require "system"
require(system.vcode..".is")

window = {}

function window.actionCheck(cmd, line)
    if is.module(cmd) == 'window' then
        local fragment = is.moduleFragment(cmd)
        if fragment == 'title' then
            love.window.setTitle(is.argument(cmd))
        elseif fragment == 'aspects' then
            local w, h, r = is.argument(cmd)
            if r == "true" then
                r = true
            else
                r = false
            end
            if w == nil or tonumber(w) == nil then
                w = 800
            end
            if h == nil or tonumber(h) == nil then
                h = 600
            end
            love.window.setMode(w, h, { resizable = r })
        elseif fragment == 'position' then
            local x, y = is.argument(cmd)
            love.window.setPosition(x, y)
        else
            print('error in line '..line..':')
            if fragment ~= '' then
                print('    Unknown Fragment "'..fragment..'"')
            else
                print('    No Fragment Given')
            end
        end
    end
end