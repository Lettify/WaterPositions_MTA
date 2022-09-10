local sx  = guiGetScreenSize()
local marks = {
    'Sudoeste (inferior esquerdo)',
    'Sudeste (inferior direito)',
    'Noroeste (superior esquerdo)',
    'Nordeste (superior direito)',
}
local actualMark = 0
local marksAdded = {}
local waterPositions = {}
local nextMark = 1
local finalWater

local function getMark()
    return actualMark and marks[actualMark] or 'Nenhum'
end

local function drawInfo()
    local nextMarkation = ''

    if (nextMark >= 0 and nextMark <= 4) then
        nextMarkation = tostring(marks[nextMark])
    end

    dxDrawText('Water Positions ATIVO', 0, 0, sx, 50, tocolor(255, 0, 0, 200), 1.85, 'arial', 'center', 'center')
    
    if (nextMarkation ~= '') then
        dxDrawText('#FFFFFF'..(nextMark == 4 and 'Última' or (nextMark == 1 and 'Primeira' or 'Próxima'))..' posição: #FF6600'..nextMarkation, 0, 50, sx, 100, tocolor(255, 255, 255, 200), 1.4, 'arial', 'center', 'center', false, false, false, true)
    end

    if (nextMark == 5) then
        dxDrawText('Gerar código com #FF6600/watergen gerar', 0, 50, sx, 100, tocolor(255, 255, 255, 200), 1.4, 'arial', 'center', 'center', false, false, false, true)
    end

    for i, v in ipairs(marksAdded) do
        dxDrawTextOnElement(v.pos[1], v.pos[2], v.pos[3]-1.5, marks[i], 1.5, 100, 255, 255, 255, 255, 1.5, 'arial')
    end
end

function addMark()
    if (getKeyState('lctrl') or getKeyState('rctrl')) then
        if (#marksAdded == 4) then
            return
        end

        local playerPos = {getElementPosition(localPlayer)}
        local x, y, z = playerPos[1], playerPos[2], playerPos[3]
        local mark = createMarker(x, y, z-1, 'checkpoint', 0.7, 255, 96, 96, 255)

        actualMark = actualMark + 1
        nextMark = actualMark + 1

        table.insert(marksAdded, { marker = mark, pos = playerPos })
        outputChatBox('#8000FF#~#FFFFFF Marcador #800FFF' .. getMark() .. '#FFFFFF adicionado com sucesso.', 0, 0, 0, true)

        if (actualMark == 4) then
            unbindKey('a', 'down', addMark)
            outputChatBox('#8000FF#~#FFFFFF Todos os marcadores foram adicionados, você pode usar estes comandos:', 0, 0, 0, true)
            outputChatBox('#8000FF#~#FF6600 /watergen gerar#FFFFFF para gerar o código com as posições;', 0, 0, 0, true)
            outputChatBox('#8000FF#~#FF6600 /watergen altura <valor>#FFFFFF para mudar a altura de todos os marcadores.', 0, 0, 0, true)

            waterPositions = {}

            for i, v in ipairs(marksAdded) do
                table.insert(waterPositions, v.pos)
            end

            finalWater = createWater(waterPositions[1][1], waterPositions[1][2], waterPositions[1][3], waterPositions[2][1], waterPositions[2][2], waterPositions[2][3], waterPositions[3][1], waterPositions[3][2], waterPositions[3][3], waterPositions[4][1], waterPositions[4][2], waterPositions[4][3])

            triggerServerEvent('onClientEndsGeneration', resourceRoot, localPlayer, waterPositions)
        end
    end
end

addEvent('onPlayerInitGeneration', true)
addEventHandler('onPlayerInitGeneration', root, function()
    addEventHandler('onClientRender', root, drawInfo)
    bindKey('a', 'down', addMark)
end)

addEvent('onPlayerChangeWaterHeight', true)
addEventHandler('onPlayerChangeWaterHeight', root, function(height)
    if (finalWater and isElement(finalWater)) then
        for i, v in ipairs(waterPositions) do
            waterPositions[i][3] = waterPositions[i][3] + height
        end

        destroyElement(finalWater)

        setTimer(
            function ()
                finalWater = createWater(waterPositions[1][1], waterPositions[1][2], waterPositions[1][3], waterPositions[2][1], waterPositions[2][2], waterPositions[2][3], waterPositions[3][1], waterPositions[3][2], waterPositions[3][3], waterPositions[4][1], waterPositions[4][2], waterPositions[4][3])
            end
        , 500, 1)

        triggerServerEvent('onClientEndsGeneration', resourceRoot, localPlayer, waterPositions)
    end
end)

addEvent('onPlayerStopGeneration', true)
addEventHandler('onPlayerStopGeneration', root, function()
    for _, v in ipairs(marksAdded) do
        if (v.marker and isElement(v.marker)) then
            destroyElement(v.marker)
        end
    end

    marksAdded = {}
    actualMark = 0
    nextMark = 1
    
    removeEventHandler('onClientRender', root, drawInfo)
    unbindKey('a', 'down', addMark)

    if (finalWater and isElement(finalWater)) then
        destroyElement(finalWater)
        finalWater = nil
    end
end)

addEvent('setClientClipboard', true)
addEventHandler('setClientClipboard', root, function(text)
    setClipboard(text)
end)

function dxDrawTextOnElement(x, y, z,text,height,distance,R,G,B,alpha,size,font,...)
	local x2, y2, z2 = getCameraMatrix()
	local distance = distance or 20
	local height = height or 1

    local sx, sy = getScreenFromWorldPosition(x, y, z+height)
    if(sx) and (sy) then
        local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
        if(distanceBetweenPoints < distance) then
            dxDrawText(text, sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1)-(distanceBetweenPoints / distance), font or "arial", "center", "center")
        end
    end
end