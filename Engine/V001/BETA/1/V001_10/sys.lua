-- system.lua

require "system"
require(system.vcode..".is")

sys = {}

function sys.actionCheck(cmd, line)
    if is.module(cmd) == 'system' then
        local frag = is.moduleFragment(cmd)
        if frag == 'quit' then
            love.event.quit('quit')
        elseif frag == 'restart' then
            love.event.quit('restart')
        elseif frag == 'cache' then
            local arg = is.argument(cmd)
            if arg == 'clear' then
                local function recursivelyDelete( item )
                    if love.filesystem.getInfo( item , "directory" ) then
                        for _, child in pairs( love.filesystem.getDirectoryItems( item )) do
                            recursivelyDelete( item .. '/' .. child )
                            love.filesystem.remove( item .. '/' .. child )
                        end
                    elseif love.filesystem.getInfo( item ) then
                        love.filesystem.remove( item )
                    end
                    love.filesystem.remove( item )
                end
                recursivelyDelete( 'cache' )
                love.filesystem.remove('code.linecode')
            elseif arg == 'dir' then
                print(love.filesystem.getSaveDirectory().."/cache/")
            else
                print(love.filesystem.getSaveDirectory().."/cache/")
            end
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

