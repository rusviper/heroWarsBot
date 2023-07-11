local LibTools = require('LibTools')
local Txt = require('Txt')
local Navigation = require('Navigation')

local Tower = {}



-------------------
------TOWER--------
-------------------

towerManualLoc = Location(780, 670)
towerNextLoc = Location(1250, 810)

firstChest = "tower/tower3Chest1.png"
smallChest = "tower/tower3Chest.png"
lastChest = "tower/tower6LastChest.png"

function findChest()
   -- ждём возможную загрузку башни или её перемещение
   wait(2)
   roomsToast("Есть че по сундукам?")
   chest = LibTools:findFirstOfList(firstChest, smallChest, lastChest)
   if (chest ~= nil) then
   	roomsToast("Сундук найден! " .. tostring(chest:getTarget()))
   else
   	roomsToast("Сундук не найден! =(")
   end
   return chest
end

function Tower:towerCollect()
    foundChest = findChest()
    if foundChest == nil then
	  Navigation:goToTower()
	  foundChest = findChest()
    end
    if foundChest == nil then
	  roomsToast("переходим к сундукам")
      LibTools:clickIfVisible("tower/tower1Start.png")
      LibTools:clickIfVisible("tower/tower2manual.png")
      -- ждём возможную загрузку башни (лучше бы сделать через поиск картинки, но корутины не работают =( )
      wait(3)
	  foundChest = findChest()
    end

    if foundChest == nil then
        roomsToast("Сундук не найден, выходим")
    	return
    end

    -- итерируем по чемоданам
    -- чемоданы отличаются по этажам
    -- искать чемодан только один раз
    for stage=1,20 do
    	if foundChest == nil then
    		roomsToast("Сундук не найден, выходим")
    		break
	end
    	roomsToast("Собираем этаж " .. stage)

    	click(foundChest)
    	LibTools:clickOnPicture("tower/tower4Open.png")
    	nextBtn = findTowerNext()

    	if nextBtn == nil then
            -- если нет кнопки 5, то это был последний этаж - выходим
            roomsToast("Башня закончилась")
            break
        else
        	click(nextBtn)
        end

    	wait(2)
    	foundChest = findChest()
    end

    Navigation:clickClose()
    -- выходим на площадь
    -- todo тут нажимается на неактивный видимый крестик, ограничить регион
    Navigation:clickClose(Region(1100, 0, 800, 300))	-- область активного видимого крестика
    Navigation:clickClose()
end

function findTowerNext()
	bereich = Region(1300, 600, 600, 400)
	return LibTools:findPicOnRegion(bereich, "tower/tower5Next.png")
end


-------------------
------TOOLS--------
-------------------

function roomsToast(toastText)
    Txt:ifToast(toastText, true)
end

return Tower