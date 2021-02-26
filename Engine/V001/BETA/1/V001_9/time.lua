-- time.lua

require 'system'
require(system.vcode..'.is')

time = {}

function time.actionCheck(cmd, line)
    if is.module(cmd) == 'time' then
        local frag = is.moduleFragment(cmd)
        if frag == 'wait' then
            love.timer.sleep(is.argument(cmd))
        else
            print('error in line '..line..':')
            if frag ~= '' then
                print('    Unknown Fragment "'..frag..'"')
            else
                print('    No Fragment Given')
            end
        end
    end
end