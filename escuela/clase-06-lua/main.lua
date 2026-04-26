local Heroe = { x = 300, y = 420, w = 28, h = 28, vel = 220, vivo = true }

local rocas         = {}
local puntuacion    = 0
local siguienteRoca = 1.0

function love.load()
    math.randomseed(os.time())
end

local function spawnRoca()
    table.insert(rocas, {
        x   = math.random(15, love.graphics.getWidth() - 15),
        y   = -20,
        r   = math.random(8, 18),
        vel = math.random(100, 200) + puntuacion * 8,
    })
end

local function colision(h, r)
    local cx = h.x + h.w / 2
    local cy = h.y + h.h / 2
    return math.sqrt((cx - r.x)^2 + (cy - r.y)^2) < (h.w / 2 + r.r)
end

local function reiniciar()
    Heroe.x, Heroe.y, Heroe.vivo = 300, 420, true
    rocas        = {}
    puntuacion   = 0
    siguienteRoca = 1.0
end

function love.update(dt)
    if not Heroe.vivo then return end

    puntuacion = puntuacion + dt

    if love.keyboard.isDown("left", "a") then
        Heroe.x = math.max(0, Heroe.x - Heroe.vel * dt)
    end
    if love.keyboard.isDown("right", "d") then
        Heroe.x = math.min(love.graphics.getWidth() - Heroe.w, Heroe.x + Heroe.vel * dt)
    end

    siguienteRoca = siguienteRoca - dt
    if siguienteRoca <= 0 then
        spawnRoca()
        siguienteRoca = math.max(0.25, 1.2 - puntuacion * 0.015)
    end

    for i = #rocas, 1, -1 do
        local r = rocas[i]
        r.y = r.y + r.vel * dt
        if r.y > love.graphics.getHeight() + 30 then
            table.remove(rocas, i)
        elseif colision(Heroe, r) then
            Heroe.vivo = false
        end
    end
end

function love.draw()
    love.graphics.clear(0.05, 0.05, 0.15)

    love.graphics.setColor(0.65, 0.40, 0.20)
    for _, r in ipairs(rocas) do
        love.graphics.circle("fill", r.x, r.y, r.r)
    end

    if Heroe.vivo then
        love.graphics.setColor(0.20, 0.80, 0.40)
    else
        love.graphics.setColor(0.80, 0.20, 0.20)
    end
    love.graphics.rectangle("fill", Heroe.x, Heroe.y, Heroe.w, Heroe.h)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(string.format("Puntos: %.1f", puntuacion), 10, 10)

    if not Heroe.vivo then
        love.graphics.setColor(1, 0.85, 0)
        love.graphics.printf(
            string.format("¡GAME OVER!\n\nPuntos: %.1f\n\nPresioná R para reiniciar", puntuacion),
            0, 160, love.graphics.getWidth(), "center"
        )
    end
end

function love.keypressed(key)
    if key == "r" and not Heroe.vivo then reiniciar() end
    if key == "escape" then love.event.quit() end
end
