-- speak.lua

require "system"
require(system.vcode..".tts")
require(system.vcode..".is")

speak = {}

function speak.actionCheck(command, line)
    if is.module(command) == "speak" or is.module(command) == 'tts' then
        local fragment = is.moduleFragment(command)
        if fragment == 'test' then
            tts:say("Tested!")
        elseif fragment == 'text' then
            local arg = is.argument(command)
            tts:say(arg)
        elseif fragment == 'version' then
            tts:speak("Running LineRun "..system.version)
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