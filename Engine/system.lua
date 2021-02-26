system = {}
system.version = "BETA 1(V0.0.1_10)"
system.vcode = "V001.BETA.1.V001_10"
system.batchType = "BETA"

system.editerActive = false

function system.startUp()
    if system.batchType == "BETA" then
        local startUpAction = love.window.showMessageBox("WARNING!", "You are currently using a BETA version of LineRun!\nThis version might have some bugs.\nIf any found please go to github site and in issues, create one about bug you found.", {"Exit LineRun", "Start LineRun"})
        if startUpAction == 1 then
            love.event.quit("quit")
        elseif startUpAction == 2 then
            print('If any bugs, report at "https://attachment-studios.github.io/LineRun/"')
        end
    end
    print(' _________________________________________________________       ')
    print('| _     _  ___     _  _______  _____  _      _  ___     _ |      ')
    print('|| |   | ||   \\   | ||  _____||  _  || |    | ||   \\   | ||    ')
    print('|| |   | || |\\ \\  | || |_____ | |_| || |    | || |\\ \\  | ||  ')
    print('|| |   | || | \\ \\ | ||  _____||    _|| |    | || | \\ \\ | ||  ')
    print('|| |__ | || |  \\ \\| || |_____ | |\\ \\ | |____| || |  \\ \\| ||')
    print('||____||_||_|   \\___||_______||_| \\_\\|________||_|   \\___||  ')
    print('|_________________________________________________________|'..system.version)
end

function system.moduleCheck(cmd, line)
    if is.module(cmd) == 'log' then
        log.actionCheck(cmd, line)
    elseif is.module(cmd) == 'ui' then
        ui.actionCheck(cmd, line)
    elseif is.module(cmd) == 'var' then
        var.actionCheck(cmd, line)
    elseif is.module(cmd) == 'speak' or is.module(cmd) == 'tts' then
        speak.actionCheck(cmd, line)
    elseif is.module(cmd) == 'math' then
        maths.actionCheck(cmd, line)
    elseif is.module(cmd) == 'system'then
        sys.actionCheck(cmd, line)
    elseif is.module(cmd) == 'window' then
        window.actionCheck(cmd, line)
    end
end

function system.doCode(filename)
    local t = {}
    for line in love.filesystem.lines(filename) do
        table.insert(t, line)
    end
    for i = 1, #t do
        t[i] = is.comment(t[i])
    end
    for i = 1, #t do
        system.moduleCheck(t[i], i)
    end
end

function system.readFile(f)
    f:open('r')
    local filename = f:getFilename()
    local fileextension = ''
    for i = 0, #filename do
        if string.getCharacter(filename, #filename-i) == '.' then
            break
        else
            fileextension = string.getCharacter(filename, #filename-i)..fileextension
        end
    end

    local filedata = f:read()
    if fileextension == 'linecode' or fileextension == 'a45' then
        love.filesystem.write('code.linecode', filedata)
        system.doCode('code.linecode')
    elseif fileextension == 'lineui' then
        love.filesystem.write('ui.linepack', filedata)
    else
        print('Error:')
        print('    Invalid file format "'..fileextension..'"')
    end
    f:close()
end

function system.checkEditerData()
    if not(love.filesystem.getInfo('cache/extensions/editor')) then
        love.filesystem.createDirectory('cache/extensions/editor')
    end
    if not(love.filesystem.getInfo('cache/extensions/editor/editor-connection.linecode')) then
        love.filesystem.write('cache/extensions/editor/editor-connection.linecode', 'engine active')
    end
    if love.filesystem.read('cache/extensions/editor/editor-connection.linecode') == 'editer active' then
        system.editerActive = true
        love.filesystem.write('cache/extensions/editor/editor-connection.linecode', 'engine active')
    else
        system.editerActive = false
    end
    if love.filesystem.getInfo('cache/extensions/editor/transmit') then
        if love.filesystem.read('cache/extensions/editor/editor-code.linecode') ~= 'received' then
            system.doCode('cache/extensions/editor/editor-code.linecode')
            love.filesystem.write('cache/extensions/editor/editor-code.linecode', 'received')
            love.filesystem.remove('cache/extensions/editor/transmit')
        end
    end
end

function system.run(dt, crashT)
    if dt > crashT then
        local action = love.window.showMessageBox("Not Responding", "Seems like LineRun is not responding.\nDo you want to restart the engine?", {"Wait", "Restart", "Exit"})
        if action == 2 then
            love.event.quit("restart")
        elseif action == 3 then
            love.event.quit("quit")
        end
    end
    system.checkEditerData()
end