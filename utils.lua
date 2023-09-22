local utils = {}

function utils.enableUtf8()
    os.execute("chcp 65001")
    os.execute("cls")
end

function utils.printHeader()
    print([[
====================================================================================

                  /}
                  //
                 /{     />
  ,_____________///----/{____________________________________________________
/|=============|/\|-----/____________________________________________________\
\|=============|\/|-----\____________________________________________________/
  '~~~~~~~~~~~~~\\\----\{
                 \{     \>
                  \\
                   \}

------------------------------------------------------------------------------------

                                SIMULADOR DE BATALHA

====================================================================================

                    Você empunha sua espada e se prepara para lutar.
                                 É hora da batalha!

]])
end

---@return string
function utils.getProgressBar(attribute)
    local fullChar = "⬜"
    local emptyChar = "⬛"
    local result = ""
    for i = 1, 10, 1 do
        result = result .. (i <= attribute and fullChar or emptyChar)
    end
    return result
end

---@param creature table
function utils.printCreature(creature)
    local healthRate = math.floor((creature.health / creature.maxHealth) * 10)

    print("| " .. creature.name)
    print("|")
    print("| " .. creature.description)
    print("|")
    print("| Attibutos")
    print("|    Vida: " .. utils.getProgressBar(healthRate))
    print("|    Ataque: " .. utils.getProgressBar(creature.attack))
    print("|    Defesa: " .. utils.getProgressBar(creature.defence))
    print("|    Velocidade: " .. utils.getProgressBar(creature.speed))
end

---@return number
function utils.ask()
    io.write("> ")
    local answer = io.read("*n")
    return answer
end

return utils
