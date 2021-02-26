-- math.lua

require 'system'
require(system.vcode..'.is')

maths = {}

function maths.actionCheck(cmd, line)
    if is.module(cmd) == 'maths' then
        local fragment = is.moduleFragment(cmd)
        if fragment == 'random' then
            local a, b = is.argument(cmd)
            print(math.random(a, b))
        end
    end
end