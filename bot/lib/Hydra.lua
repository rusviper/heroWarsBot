local LibTools = require('LibTools')
local Txt = require('Txt')
local Navigation = require('Navigation')

local Hydra = {}


-------------------
-----HYDRA---------
-------------------

-- пока в разработке
function Hydra:hydraCollectFull()
    -- перемещаемся к гидрам
    Navigation:goToHydras()
    -- идём к последним гидрам
    LibTools:clickIfVisible("hydra/hydra1Next.png")
    -- идём к кошмарной
    LibTools:clickIfVisible("hydra/hydra2h4.png")
    -- todo определять доступные головы
    hydraHead = "hydra/hydra3water.png"
    for i=1,3 do
        roomsToast("Атакуем гидру (" .. i .."/3)")
        if exists(hydraHead) then
            LibTools:clickOnPicture(hydraHead)

            -- забираем одну гидру
            oneHydraThreeHeads()
        else
            roomsToast("Голова гидры не найдена")
        end
    end
    -- выходим из гидры
    Navigation:clickClose()
end

-- пока что основная функция сбора гидры
function Hydra:hydraCollect()
    oneHydraThreeHeads()
end

function oneHydraThreeHeads()
    -- выбрана голова и находимся на экране формирования атакующих команд
    -- нужные герое, есессно, должны быть уже выбраны
    -- нажимаем "дальше"-"дальше"-"в бой!"
    select3Teams()
    -- пропускаем бой
    hydraTakeHead()
    -- дожидаемся завершения боя и нажимаем "следующий бой"
    hydraNextHead()
    -- пропускаем второй бой
    hydraTakeHead()
    hydraNextHead()
    hydraTakeHead()
    -- после третьего боя уже кнопка "ОК" и выход к головам
    hydraEndHeads()
    -- после этого оказываемся на головах
end

-- нажимаем "дальше"-"дальше"-"в бой!"
function select3Teams()
    LibTools:clickOnPicture("hydra/hydra4NextTeam.png")
    LibTools:clickOnPicture("hydra/hydra4NextTeam.png")
    LibTools:clickOnPicture("hydra/hydra5Fight.png")
end

-- нажимаем "пауза", "пропустить"
function hydraTakeHead()
    -- атака уже начинается (нажали "в бой" или "следующий бой")
    LibTools:clickOnPicture("hydra/hydra6Pause.png", 15)    -- ждём подольше, т.к. бой долго прогружается иногда
    LibTools:clickOnPicture("hydra/hydra7Skip.png")
end

function hydraNextHead()
    LibTools:clickOnPicture("hydra/hydra8NextHead.png")
end

function hydraEndHeads()
    LibTools:clickOnPicture("hydra/hydra9Ok.png")
end



-------------------
------TOOLS--------
-------------------

function roomsToast(toastText)
    Txt:ifToast(toastText, true)
end