local LibTools = require('LibTools')
local Txt = require('Txt')
local Navigation = require('Navigation')

local Tower = {}



-------------------
------TOWER--------
-------------------

towerManualLoc = Location(780, 670)
towerNextLoc = Location(1250, 810)


chestButton="tower/ChestBtn.png"
nextLevelButton="tower/NextLevelBtn.png"
goFreeButton="tower/GoFreeBtn.png"
chestIcon="tower/TowerChest.png"
girlIcon="tower/TowerGirl.png"


firstChest = "tower/tower3Chest1.png"
smallChest = "tower/tower3Chest.png"
lastChest = "tower/tower6LastChest.png"

-- при запуске проверяем где находимся:
-- Сначала надеемся, что находимся на сундуках, проверяем
-- 1) Если виден сундук башни? Нажимаем chestButton
-- 1.1) Далее нажимаем nextLevelButton
-- Если сундук не виден, то доходим до них
-- 2) В городе? Заходим в башню
-- 3) В стартовом окне (GoFree)? Нажимаем "вперёд"
-- 3.1) Заходим на цикл башни
-- 4) Находимся на последнем этаже? Выходим

function findChest2()
   -- ждём возможную загрузку башни или её перемещение
   wait(2)
   roomsToast("Есть че по сундукам?")
   chest = LibTools:exists(chestIcon, 5)
    if (chest ~= nil) then
        roomsToast("Сундук найден! " .. tostring(chest:getTarget()))

        -- нажимаем кнопку под сундуком
        foundChestButton = LibTools:clickIfVisible(chestButton, 3)
        return foundChestButton
    else
        roomsToast("Сундук не найден! =(")
        return nil
    end
end
function findChest()
    -- ждём возможную загрузку башни или её перемещение
    wait(2)
    roomsToast("Есть че по сундукам?")
    -- нажимаем кнопку под сундуком
    foundChestButton = LibTools:clickIfVisible(chestButton, 3)


    --chest = LibTools:exists(chestIcon, 5)
    if (foundChestButton ~= nil) then
        roomsToast("Сундук найден! " .. tostring(foundChestButton:getTarget()))


        return foundChestButton
    else
        roomsToast("Сундук не найден! =(")
        return nil
    end
end


-- корневой метод меню ---
function Tower:towerCollect()
    foundChest = findChest()
    if foundChest == nil then
        -- находимся в центре? идём в башню
    	Navigation:goToTower()
    	foundChest = findChest()
    end
    if foundChest == nil then
      -- пропускаем начальную валькирию, если она показывается
	  skipTowerStartValkyrieIfVisible()
	  foundChest = findChest()
    end

    if foundChest == nil then
        roomsToast("Сундук не найден, выходим")
    	return
    end

    -- итерируем по чемоданам до 20 раз
    -- чемоданы отличаются по этажам
    -- искать чемодан только один раз
    for stage=1,20 do
    	if foundChest == nil then
    		roomsToast("Сундук не найден, выходим")
    		break
	    end
    	roomsToast("Собираем этаж " .. stage)

    	click(foundChest)
    	--nextBtn = LibTools:clickOnPicture(nextLevelButton)
    	nextBtn = findTowerNext(nextLevelButton)

    	if nextBtn == nil then
            -- если нет кнопки 5, то это был последний этаж - выходим
            roomsToast("Башня закончилась")
            break
        else
        	click(nextBtn)
        end

    	wait(3)
    	foundChest = findChest()
    end
    
    -- закрываем сундуки
    Navigation:clickClose()

    -- закрываем заключительное окно
    Navigation:clickClose(Region(1100, 0, 800, 300))	-- область активного видимого крестика
    -- выходим на площадь
    Navigation:clickClose()
end

-- возвращает not nil если успешно пройдено
function skipTowerStartValkyrieIfVisible()
    -- ищем характеристику окна
    towerStartFound = LibTools:exists(girlIcon)
    if towerStartFound == nil then
        return nil
    end

    -- нажимаем кнопку "вперёд"
    roomsToast("Запускаем башню, первые шаги")
    goFreeFound = LibTools:clickIfVisible(goFreeButton)

    -- ждём возможную загрузку башни (лучше бы сделать через поиск картинки, но корутины не работают =( )
    wait(3)

    return goFreeFound
end

-- ищет картинку в правом нижнем углу
function findTowerNext(picName)
	bereich = Region(1300, 600, 600, 400)
	return LibTools:findPicOnRegion(bereich, picName)
end


-------------------
------TOOLS--------
-------------------

function roomsToast(toastText)
    Txt:ifToast(toastText, true)
end

return Tower