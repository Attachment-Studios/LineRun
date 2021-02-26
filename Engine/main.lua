-- main.lua

--- SYSTEM-MODULES ---
require ('system')
require (system.vcode..'.CI')
require (system.vcode..'.is')

--- COMMAND-MODULES ---
require (system.vcode..'.log')
require (system.vcode..'.var')
require (system.vcode..'.tts')
require (system.vcode..'.speak')
require (system.vcode..'.math')
require (system.vcode..'.sys')
require (system.vcode..'.window')

--- GENERAL-MODULES ---
require (system.vcode..'.UI')

--- ENGINE-START-UP ---
function love.load()
    system.startUp()
end

--- ENGINE-DISPLAY ---
function love.draw()
    ui.draw()
end

--- ENGINE-WORKING ---
function love.update(dt)
    system.run(dt, 10)
end

function love.filedropped(f)
    system.readFile(f)
end

