-- var.lua

require 'system'
require(system.vcode..'.is')
require(system.vcode..'.CI')

var = {}
var.name = {}
var.value = {}
var.type = {}

var.new = {}

function var.new.num(name)
    table.insert(var.name, name)
    table.insert(var.value, 0)
    table.insert(var.type, 'num')
end
function var.new.lgc(name)
    table.insert(var.name, name)
    table.insert(var.value, false)
    table.insert(var.type, 'lgc')
end
function var.new.str(name)
    table.insert(var.name, name)
    table.insert(var.value, 'text')
    table.insert(var.type, 'str')
end
function var.setVal(varname, varval, line)
    if varval ~= nil or varval ~= '' then
        for i = 1, #var.name do
            if var.name[i] == varname then
                if var.type[i] == 'num' then
                    if tonumber(varval) ~= nil then
                        var.value[i] = varval
                    else
                        print('error in line '..line..':')
                        print('    number expected')
                    end
                elseif var.type[i] == 'lgc'then
                    if varval == 'true' then
                        var.value[i] = true
                    elseif varval == 'false' then
                        var.value[i] = false
                    else
                        print('error in line '..line..':')
                        print('    logic expected')
                    end
                else
                    var.value[i] = varval
                end
            end
        end
    else
        print('error in line '..line..':')
        print('    no value to update')
    end
    for _, v in ipairs(var.name) do
        if v ~= varname then
            print('error in line '..line..':')
            print('    variable "'..varname..'" doesn\'t exist')
        end
    end
end
function var.getVal(varname, line)
    for i = 1, #var.name do
        if var.name[i] == varname then
            print(var.value[i])
        end
    end
    for _, v in ipairs(var.name) do
        if v ~= varname then
            print('error in line '..line..':')
            print('    variable "'..varname..'" doesn\'t exist')
        end
    end
end
function var.type(varname, line)
    for i = 1, #var.name do
        if var.name[i] == varname then
            print(var.type[i])
        end
    end
    for _, v in ipairs(var.name) do
        if v ~= varname then
            print('error in line '..line..':')
            print('    variable "'..varname..'" doesn\'t exist')
        end
    end
end

function var.actionCheck(command, line)
    if is.module(command) == 'var' then
        local fragment = is.moduleFragment(command)
        if fragment == 'num' then
            var.new.num(is.argument(command))
        elseif fragment == 'lgc' then
            var.new.lgc(is.argument(command))
        elseif fragment == 'str' then
            var.new.str(is.argument(command))
        elseif fragment == 'getVal' then
            local varname = is.argument(command)
            var.getVal(varname, line)
        elseif fragment == 'setVal' then
            local varname, varval = is.argument(command)
            var.setVal(varname, varval, line)
        elseif fragment == 'typeTable' then
            local varname = is.argument(command)
            var.type(varname, line)
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