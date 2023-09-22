local utils = require "utils"
local actions = {}

actions.list = {}

function actions.build()
    actions.list = {}

    local swordAttack = {
        description = "Atacar com a espada.",
        requirement = nil,
        execute = function(player, creature)
            local successChance = creature.speed == 0 and 1 or player.speed / creature.speed
            local success = math.random() <= successChance

            local rawDamage = player.attack - math.random() * creature.defence
            local damage = math.max(1, math.ceil(rawDamage))

            if success then
                creature.health = creature.health - damage

                print(string.format("%s atacou o %s e deu %d pontos de dano!", player.name, creature.name, damage))
                local healthBar = (utils.getProgressBar(math.floor(creature.health / creature.maxHealth * 10)))
                print(string.format("%s: %s", creature.name, healthBar))
            else
                print(string.format("O vento sobrou e %s errou!", player.name))
            end
        end
    }

    local regenPotion = {
        description = "Tomar uma poção de regeneração.",
        requirement = function(player, creature)
            return player.potions >= 1
        end,
        execute = function(player, creature)
            player.potions = player.potions - 1

            local regenPoints = 10
            player.health = math.min(player.maxHealth, player.health + regenPoints)
            print(string.format("%s recuperou alguns pontos de vida.", player.name))
        end
    }

    actions.list[#actions.list + 1] = swordAttack
    actions.list[#actions.list + 1] = regenPotion
end

---Retorna a lista de ações válidas
---@param player table
---@param creature table
---@return table
function actions.getValidActions(player, creature)
    local validAction = {}
    for _, action in pairs(actions.list) do
        local requirement = action.requirement
        local isValid = requirement == nil or requirement(player, creature)
        if isValid then
            validAction[#validAction + 1] = action
        end
    end
    return validAction
end

return actions
