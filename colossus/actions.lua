local utils = require "utils"
local actions = {}

actions.list = {}

function actions.build()
    actions.list = {}

    local bodyAttack = {
        description = "Atacar com o corpo.",
        requirement = nil,
        execute = function(player, creature)
            local successChance = player.speed == 0 and 1 or creature.speed / player.speed
            local success = math.random() <= successChance

            local rawDamage = creature.attack - math.random() * player.defence
            local damage = math.max(1, math.ceil(rawDamage))

            if success then
                player.health = player.health - damage

                print(string.format("%s atacou o %s e deu %d pontos de dano!", creature.name, player.name, damage))
                local healthBar = (utils.getProgressBar(math.floor(player.health / player.maxHealth * 10)))
                print(string.format("%s: %s", player.name, healthBar))
            else
                print(string.format("%s esquivou.", player.name))
            end
        end
    }

    local sonarAttack = {
        description = "Ataque sonar",
        requirement = nil,
        execute = function(player, creature)
            local rawDamage = creature.attack - math.random() * player.defence
            local damage = math.max(1, math.ceil(rawDamage * 0.3))

            player.health = player.health - damage

            print(string.format("%s atacou o %s com um sonar e deu %d pontos de dano!", creature.name, player.name,
                damage))
            local healthBar = (utils.getProgressBar(math.floor(player.health / player.maxHealth * 10)))
            local text = string.format("%s: %s", player.name, healthBar)
            print(text)
        end
    }

    local awaitAction = {
        description = "Agurdar",
        requirement = nil,
        execute = function(player, creature)
            print(string.format("%s decidiu não fazer nada!", creature.name))
        end
    }

    actions.list[#actions.list + 1] = bodyAttack
    actions.list[#actions.list + 1] = sonarAttack
    actions.list[#actions.list + 1] = awaitAction
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
