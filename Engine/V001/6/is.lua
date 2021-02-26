-- iteration system.lua

require 'system'
require(system.vcode..'.CI')

is = {}

function is.module(commandString)
    local moduleName = ''
    for i = 1, string.len(commandString)+1 do
        if string.getCharacter(commandString, i) == '.' or string.getCharacter(commandString, i) == '(' or i == string.len(commandString)+1 then
            do return moduleName end
        else
            moduleName = moduleName..(string.getCharacter(commandString, i))
        end
    end
end

function is.moduleFragment(command)
    local moduleName = is.module(command)..'.'
    local fragment = ''
    for i = 1, string.len(command)-string.len(moduleName) do
        fragment = fragment..string.getCharacter(command, i+string.len(moduleName))
    end
    return is.module(fragment)
end

function is.comment(str)
    local realValue = ''
    local realValueEnd = #str
    for i = 1, #str do
        if string.getCharacter(str, i) == '-' then
            if string.getCharacter(str, i+1) == '-' then
                if string.getCharacter(str, i+2) == '>' then
                    if string.getCharacter(str, i+3) == '$' then
                        realValueEnd = i-1
                    end
                end
            end
        end
    end
    for u = 1, realValueEnd do
        realValue = realValue..string.getCharacter(str, u)
    end
    return realValue
end

function is.argument(command, line)
    local commandFunctionValue = is.module(command).."."..is.moduleFragment(command)
    if string.getCharacter(command, string.len(commandFunctionValue)+1) == '(' then
        commandFunctionValue = commandFunctionValue.."("
    end
    commandFunctionValue = string.len(commandFunctionValue)
    local parenthesisValue = ''
    for i = 1, (#command-commandFunctionValue) do
        if string.getCharacter(command, i+commandFunctionValue) ~= ')' then
            if i ~= (#command-commandFunctionValue) then
                parenthesisValue = parenthesisValue..string.getCharacter(command, i+commandFunctionValue)
            elseif i == (#command)-commandFunctionValue then
                print('Error in line '..line..':')
                print('    Expected ")" in last to end function arguments(s)')
                parenthesisValue = ''
            end
        elseif string.getCharacter(command, i+commandFunctionValue) == ')' then
            break
        end
    end
    local args = {}
    local processingArg = ''
    for i = 1, #parenthesisValue+1 do
        if string.getCharacter(parenthesisValue, i) == ',' or i == #parenthesisValue+1 then
            table.insert(args, processingArg)
            processingArg = ''
        else
            if string.getCharacter(parenthesisValue, i) ~= ' ' then
                processingArg = processingArg..string.getCharacter(parenthesisValue, i)
            end
        end
    end
    return unpack(args)
end

