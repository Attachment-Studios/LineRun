-- speacial iterations

require 'system'
require(system.vcode..'.CI')

var = {}
var.name = {}
var.value = {}
var.typeTable = {}

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

function is.bracketValue(command, line)
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
    local strActive = false
    for i = 1, #parenthesisValue+1 do
        if string.getCharacter(parenthesisValue, i) == ',' or i == #parenthesisValue+1 then
            if not(strActive) or i == #parenthesisValue+1 then
                table.insert(args, processingArg)
                processingArg = ''
            else
                processingArg = processingArg..string.getCharacter(parenthesisValue, i)
            end
        else
            if string.getCharacter(parenthesisValue, i) ~= ' ' then
                if string.getCharacter(parenthesisValue, i) == '"' then
                    strActive = not(strActive)
                else
                    processingArg = processingArg..string.getCharacter(parenthesisValue, i)
                end
            end
            if string.getCharacter(parenthesisValue, i) == ' ' then
                if strActive then
                    processingArg = processingArg..string.getCharacter(parenthesisValue, i)
                end
            end
        end
    end
    if strActive then
        print('error in line '..line..':')
        print('    Expected string ending so that more than one argument can be read if any')
    end
    return unpack(args)
end

function is.argument(command, line)
    local args = {is.bracketValue(command)}
    for i = 1, #args do
        if is.module(args[i]) == 'var' then
            if is.moduleFragment(args[i]) == 'getVal' then
                local varname = is.bracketValue(args[i]..")", line)
                local varExist = false
                for u = 1, #var.name do
                    if var.name[u] == varname then
                        varExist = true
                        args[i] = var.value[u]
                    end
                end
                if not(varExist) then
                    print('error in line '..line..':')
                    print('    Unrecognized variable "'..varname..'"')
                end
            elseif is.moduleFragment(args[i]) == 'type' then
                local varExist = false
                local varname = is.bracketValue(args[i]..")", line)
                for u = 1, #var.name do
                    if var.name[u] == varname then
                        varExist = true
                        args[i] = var.typeTable[u]
                    end
                end
                if not(varExist) then
                print('error in line '..line..':')
                print('    Unrecognized variable "'..varname..'"')
                end
            else
                print('error in line '..line..':')
                if is.moduleFragment(args[i]) ~= '' then
                    print('    Command "var.'..is.moduleFragment(args[i]..")")..'" is not a return value command')
                else
                    print('    No Fragment Given')
                end
            end
        end
    end
    return unpack(args)
end

