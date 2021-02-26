require('system')

function love.conf(t)
    t.console = true

    t.identity = 'LineRun'
    
    t.window.title = 'LineRun Engine '..system.version
    t.window.icon = 'LineRun Icon.png'
end

