-- log module

require 'system'
require (system.vcode..'.is')

log = {}

--- FUNCTIONS ---
function log.test()
    print('tested!')
end
function log.version()
    print(system.version)
end
function log.text(str)
    print(str)
end

--- ACTION-CHECKS ---
function log.actionCheck(command, line)
    if is.module(command) == 'log' then
        local fragment = is.moduleFragment(command)
        if fragment == 'test' then
            log.test()
        elseif fragment == 'version' then
            log.version()
        elseif fragment == 'text' then
            log.text(is.argument(command, line))
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

