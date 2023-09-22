-- Dependencies
local utils = require("utils")
local player = require("player.player")
local playerActions = require("player.actions")
local colossus = require("colossus.colossus")
local colossuActions = require("colossus.actions")


utils.enableUtf8()

-- Header
utils.printHeader()

local boss = colossus
local bossActions = colossuActions
-- Monstro
utils.printCreature(boss)

playerActions.build()
bossActions.build()


-- Começar o loop do simulador

while true do
    print()
    print()
    print(string.format("O que %s deseja fazer em seguida?", player.name))
    local validPlayerActions = playerActions.getValidActions(player, boss)
    for i, action in pairs(validPlayerActions) do
        print(string.format("%d. %s", i, action.description))
    end
    local chosenIndex = utils.ask()
    local choosenAction = validPlayerActions[chosenIndex]
    local isActionValid = choosenAction ~= nil
    print()
    print()
    if isActionValid then
        choosenAction.execute(player, boss)
    else
        print(string.format("Escolha inválida. %s não se moveu!", player.name))
    end

    if boss.health <= 0 then
        print()
        print("====================================================================================")
        print()
        print(string.format("%s foi derrotado, %s ganhou!", boss.name, player.name))
        print()
        print("====================================================================================")
        print()
        break
    end

    print()
    print()
    local validBossActions = bossActions.getValidActions(player, boss)
    local bossAction = validBossActions[math.random(#validBossActions)]
    bossAction.execute(player, boss)


    if player.health <= 0 then
        print()
        print("====================================================================================")
        print()
        print(string.format("%s foi derrotado, %s ganhou!", player.name, boss.name))
        print()
        print("====================================================================================")
        print()
        break
    end
end
