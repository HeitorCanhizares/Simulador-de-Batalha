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

    local drinkPotion = {
        description = "Toma uma das poções que tem na mochila.",
        requirement = function(player, creature)
            return player.speedPotions >= 1 or player.defencePotions >= 1
        end,
        execute = function(player, creature)
            local potions = {}
            potions[#potions + 1] = {
                description = "Poção de Velocidade",
                buff = "50% a mais de velocidade base!",
                quantity = player.speedPotions,
                status = "speed",
                multiplier = 0.5,
                time = 4,
                type = "speedPotions",
            }
            potions[#potions + 1] = {
                description = "Poção de Defesa",
                buff = "dobrou a defesa!",
                quantity = player.defencePotions,
                status = "defence",
                multiplier = 2,
                time = 4,
                type = "defencePotions"
            }

            for i, potion in pairs(potions) do
                if potion.quantity >= 1 then
                    print(string.format("%d. %s - %d", i, potion.description, potion.quantity))
                end
            end
            print()
            print("Qual irá tomar?")

            local option = utils.ask()
            local chosenPotion = potions[option]

            print(string.format("%s toma a poção de %s, ganhando um bônus de %s", player.name,
                chosenPotion.description,
                chosenPotion.buff))

            local buffStatus = chosenPotion.status
            local buffValue = math.floor(player[buffStatus] * chosenPotion.multiplier + 0.1)

            player.buffs[buffStatus] = {
                description = chosenPotion.description,
                value = buffValue,
                time = chosenPotion.time
            }

            player[buffStatus] = player[buffStatus] + buffValue
            player[chosenPotion.type] = player[chosenPotion.type] - 1
        end
    }


    actions.list[#actions.list + 1] = swordAttack
    actions.list[#actions.list + 1] = regenPotion
    actions.list[#actions.list + 1] = drinkPotion
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
