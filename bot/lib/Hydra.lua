local LibTools = require('LibTools')
local Txt = require('Txt')
local Navigation = require('Navigation')

local Hydra = {}


-------------------
-----HYDRA---------
-------------------

-- ждем тык, а затем три раза собираем по нему гидру
function Hydra:treeHydraFromPoint()
  local hydraStart = LibTools:getTapStartPoint()
  
   for i = 1,3 do
       roomsToast("Атакуем гидру (" .. i .."/3)")
       LibTools:tapWithShow(hydraStart)
       oneHydraThreeHeads()
   end
end



-- пока что основная функция сбора гидры
function Hydra:hydraCollect()
    Hydra:treeHydraFromPoint()
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
    --hydraTakeHead()
    --hydraNextHead()
    --hydraTakeHead()
    -- после третьего боя уже кнопка "ОК" и выход к головам
    --hydraEndHeads()
    -- после этого оказываемся на головах
end

-- нажимаем "дальше"-"дальше"-"в бой!"
function select3Teams()
    LibTools:clickOnPicture("hydra/hydra4NextTeam.png")
    LibTools:clickOnPicture("hydra/hydra4NextTeam.png")
    --LibTools:clickOnPicture("hydra/hydra5Fight.png")
    LibTools:clickOnPicture("hydra/hydra4NextTeam.png")
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



return Hydra