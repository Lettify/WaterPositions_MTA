local generating = {}
local playerGenPositions = {}

local function setPlayerClipboard(player, text)
    if (not (isElement(player) and getElementType(player) == 'player')) then
        return
    end

    triggerClientEvent(player, 'setClientClipboard', resourceRoot, text)
end

addEventHandler('onResourceStart', resourceRoot, 
    function ()
        local players = {}

        for i, v in ipairs(getElementsByType('player')) do
            if (hasObjectPermissionTo(v, 'function.banPlayer', false)) then
                table.insert(players, v)
            end
        end

        outputChatBox('#8000FF#~#FFFFFF Resource #8000FFWater Generator#FFFFFF iniciado. Use #8000FF/watergen#FFFFFF para pegar as posições.', players, 0, 0, 0, true)
    end
)

addEvent('onClientEndsGeneration', true)
addEventHandler('onClientEndsGeneration', root, 
    function (player, positions)
        if (not generating[player]) then return end

        playerGenPositions[player] = positions
    end
)

addCommandHandler('watergen',
    function (s, _, subcmd, arg1)
        if (not generating[s] and not subcmd) then
            generating[s] = true
            triggerClientEvent(s, 'onPlayerInitGeneration', resourceRoot)
            outputChatBox('#8000FF#~#FFFFFF Use #8000FFCTRL + A#FFFFFF para adicionar os marcadores. Se quiser cancelar, use o #8000FF/watergen cancelar', s, 0, 0, 0, true)
        else
            if (not subcmd) then
                outputChatBox('#8000FF#~#FFFFFF Você já está com a geração das posições habilitadas. Caso queira cancelar, use o comando #8000FF/watergen cancelar', s, 0, 0, 0, true)
            elseif (subcmd == 'cancelar') then
                generating[s] = nil
                outputChatBox('#8000FF#~#FFFFFF Você cancelou a geração de posições.', s, 0, 0, 0, true)
                triggerClientEvent(s, 'onPlayerStopGeneration', resourceRoot)
            elseif (subcmd == 'gerar') then
                if (not generating[s]) then
                    outputChatBox('#8000FF#~#FFFFFF Você não está gerando posições.', s, 0, 0, 0, true)
                    return
                end
                if (not playerGenPositions[s]) then
                    outputChatBox('#8000FF#~#FFFFFF Você não finalizou a marcação.', s, 0, 0, 0, true)
                    return
                end

                generating[s] = nil

                local str = 'createWater('

                for i, v in ipairs(playerGenPositions[s]) do
                    local x, y, z = tostring(v[1]), tostring(v[2]), tostring(v[3])

                    if (i == 4) then
                        str = str .. x .. ', ' .. y .. ', ' .. z .. ')'
                    else
                        str = str .. x .. ', ' .. y .. ', ' .. z .. ', '
                    end
                end

                outputChatBox('#8000FF#~#FFFFFF Gerado e copiado para sua #FF6600área de transferência#FFFFFF!', s, 0, 0, 0, true)
                outputChatBox('#8000FF#~#FFFFFF Use #8000FFCTRL + V#FFFFFF para colar no seu script.', s, 0, 0, 0, true)

                setPlayerClipboard(s, str)

                triggerClientEvent(s, 'onPlayerStopGeneration', resourceRoot)
            elseif (subcmd == 'altura') then
                if (not generating[s]) then
                    outputChatBox('#8000FF#~#FFFFFF Você não está gerando posições.', s, 0, 0, 0, true)
                    return
                end
                if (not playerGenPositions[s]) then
                    outputChatBox('#8000FF#~#FFFFFF Você não finalizou a marcação.', s, 0, 0, 0, true)
                    return
                end

                arg1 = tonumber(arg1)
                if (not arg1) then return outputChatBox('#8000FF#~#FFFFFF O valor de #8000FFaltura#FFFFFF deve ser um número!', s, 0, 0, 0, true) end

                triggerClientEvent(s, 'onPlayerChangeWaterHeight', resourceRoot, arg1)

                outputChatBox('#8000FF#~#FFFFFF Você alterou a altura para #8000FF'..arg1..'#FFFFFF da altura original.', s, 0, 0, 0, true)
            end
        end
    end
, true)

addEventHandler('onPlayerQuit', root, 
    function ()
        generating[source] = nil
        playerGenPositions[source] = nil
    end
)