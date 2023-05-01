local LibTools = require('LibTools')

local Rooms = {}

toastOn = true

adCloseLocation = Location(1940, 140)

-------------------
------TOOLS--------
-------------------

function roomsToast(toastText)
    LibTools:ifToast(toastText, toastOn)
end

-------------------
------TITANS-------
-------------------
function Rooms:titanCollect()
-- идём в подземелье
  if not isTitanDoorVisible() then
    roomsToast("Идём в подземелье")
    goToUnderground()
  end
-- проходим по дверям, пока не достигнем кнопки погружения
  while not isStageCompleted() do
    titanCompleteOneDoor()
  end
  roomsToast("Подземелье закончилось - выходим")
  Rooms:clickClose()
  exitFromGuild()
end

function isTitanDoorVisible()
    return exists("titan/titanDoor.png")
end

function isStageCompleted()
    return exists("titan/titanDigDeep2.png")
end

function titanCompleteOneDoor()
  roomsToast("Соберём и эту дверь")
  -- жмём на дверь "в бой"
  LibTools:clickOnPicture("titan/titanDoor.png")
  -- жмём на кнопку "напасть"
  LibTools:clickOnPicture("titan/titanAttack.png")
  -- жмём на кнопку "автобой"
  LibTools:clickOnPicture("titan/titanAutoFight.png")
  -- жмём на кнопку "OK"
  LibTools:clickOnPicture("titan/titanOK.png")
end

-------------------
------TOWER--------
-------------------

towerManualLoc = Location(780, 670)
towerNextLoc = Location(1250, 810)

firstChest = "tower/tower3Chest1.png"
smallChest = "tower/tower3Chest.png"
lastChest = "tower/tower6LastChest.png"

function findChest()
   roomsToast("Есть че по сундукам?")
   chest = LibTools:findFirstOfList(firstChest, smallChest, lastChest)
   if (chest ~= nil) then
   	roomsToast("Сундук найден! " .. tostring(chest:getTarget()))
   else
   	roomsToast("Сундук не найден! =(")
   end
   return chest
end

function Rooms:towerCollect()
    foundChest = findChest()
    if foundChest == nil then
	  goToTower()
	  foundChest = findChest()
    end
    if foundChest == nil then
	  roomsToast("переходим к сундукам")
      LibTools:clickIfVisible("tower/tower1Start.png")
      LibTools:clickIfVisible("tower/tower2manual.png")
      --wait(1)
      --click(towerManualLoc)
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
    	if not foundChest then
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

    Rooms:clickClose()
    -- выходим на площадь
    -- todo тут нажимается на неактивный видимый крестик, ограничить регион
    Rooms:clickClose(Region(1100, 0, 800, 300))	-- область активного видимого крестика
    Rooms:clickClose()
end

function findTowerNext()
	bereich = Region(1300, 600, 600, 400)
	return LibTools:findPicOnRegion(bereich, "tower/tower5Next.png")
end

-------------------
-------AD----------
-------------------


function Rooms:adCollect()
-- идём к девке
  if isOnTown() then
    roomsToast("Переходим к рекламным сундукам")
    LibTools:clickOnPicture("ad/ad1Girl.png")
    wait(3) -- ждем вращения сундуков
  else
    roomsToast("Находимся не в деревне")
  end


  adCollectOneByStartPic("ad/ad2Box.png")

  LibTools:clickIfVisible("ad/ad3ToShop.png")

  adCollectOneByStartPic("ad/ad4Shop.png")

  roomsToast("Больше не видно рекламы")
  -- выходим в город
  wait(1)
  Rooms:clickClose()
end

-- собираем рекламу, пока видна кнопка
function adCollectOneByStartPic(adButton)
  adBtn = LibTools:exists(adButton)
  while adBtn ~= nil do
    roomsToast("Собираем рекламку")
    click(adBtn)
    -- ждём окончания рекламы до 40 сек
    if not Rooms:waitAdEnd(40) then
        roomsToast("Не смогли закрыть рекламу")
        click(adCloseLocation)
    end
    -- ждём, пока одуплится следующая реклама
    wait(7)
    adBtn = LibTools:exists(adButton)
  end
end
closeAdPic = "ad/ad5Close.png"
function Rooms:closeAd()
    return LibTools:clickOnPicture(closeAdPic)
end

-- найти крестик, подождать 3 сек и ткнуть в то место
function Rooms:waitAdEnd(timeout)
    rval = LibTools:clickOnPicture(closeAdPic, 1, nil, timeout)
    if rval == nil then return false end
    -- после первого нажатия снова появляется ещё один крестик
    -- пробуем подождать его, но ничего, если не получится
    wait(2)
    LibTools:clickIfVisible(closeAdPic, 1, nil, 3)
    return true
end


-------------------
-----HYDRA---------
-------------------

-- пока в разработке
function Rooms:hydraCollectFull()
    -- перемещаемся к гидрам
    goToHydras()
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
    Rooms:clickClose()
end

function Rooms:hydraCollect()
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

function select3Teams()
    -- нажимаем "дальше"-"дальше"-"в бой!"
    LibTools:clickOnPicture("hydra/hydra4NextTeam.png")
    LibTools:clickOnPicture("hydra/hydra4NextTeam.png")
    LibTools:clickOnPicture("hydra/hydra5Fight.png")
end

function hydraTakeHead()
    -- атака уже началась (нажали "" или "следующий бой")
    wait(5) -- ждем загрузки боя
    LibTools:clickOnPicture("hydra/hydra6Pause.png")
    LibTools:clickOnPicture("hydra/hydra7Skip.png")
end

function hydraNextHead()
    LibTools:clickOnPicture("hydra/hydra8NextHead.png")
end

function hydraEndHeads()
    LibTools:clickOnPicture("hydra/hydra9Ok.png")
end
--------------------
-----OUTLAND--------
--------------------

function Rooms:outlandCollect()
    -- идём в запределье
    LibTools:clickIfVisible("town/outland.png")
    -- выбираем боссов
    findByIndex("outland/outland1Enter.png", 1) -- правая кнопка
    -- выбираем босса1
    oneChestBoss("outland/outland2Boss1.png")
    oneChestBoss("outland/outland3Boss2.png")
    oneChestBoss("outland/outland4Boss3.png")
    oneChestBoss("outland/outland4Boss3.png")
    oneChestBoss("outland/outland4Boss3.png")
end

function oneChestBoss(bossPic)
    -- должны находиться на выборе одного из 3 боссов
    LibTools:clickPicOnPic(bossPic, "outland/outland6Select.png")
    LibTools:clickOnPicture("outland/outland5Forward.png")
    wait(1)
    LibTools:clickOnPicture("outland/outland6Select.png") -- рейд
    LibTools:clickOnPicture("outland/outland7Free.png") -- бесплатно
    wait(3)
    Rooms:clickClose() -- выход
    Rooms:clickClose() -- ещё выход
    Rooms:clickClose() -- оказываемся у боссов
end


-------------------
-----NAVIGATION----
-------------------

--- закрытие интерфейса в игре
function Rooms:clickClose(region)
    if region == nil then
        region = getGameArea()
    end
    closeBtn = "town/close.png"
    close = LibTools:findPicOnRegion(region, closeBtn)
    if close ~= nil then
	roomsToast("Жмем на крестик")
    	click(close)
    else
    	roomsToast("Крестик не найден")
    end
end

function goToHydras()
    roomsToast("Идем к гидре")
    if isOnTown() then
        goToGuild()
    end
    if isOnGuild() then
        goToNestOfElements()
    end
    if isOnNestOfElements() then
        goToRuins() -- попадаем к гидре
    end
end

function goToUnderground()
    roomsToast("Идем в подземелье")
    if isOnTown() then
        goToGuild()
    end
    if isOnGuild() then
        LibTools:clickOnPicture("town/toTitans.png")
    end
end

function goToTower()
    roomsToast("Идем в башню")
    if isOnTown() then
        LibTools:clickOnPicture("town/tower.png")
    end
end

function exitFromGuild()
    if isOnGuild() then
        LibTools:clickOnPicture("town/guildToTown.png")
    end
end
function isOnTown()
    return LibTools:exists("town/toGuild.png")
end
function goToGuild()
    LibTools:clickOnPicture("town/toGuild.png")
end
function isOnGuild()
    return exists("town/toTitans.png")
end
function goToNestOfElements()
    LibTools:clickOnPicture("town/toNest.png")
end
function isOnNestOfElements()
    return exists("town/toHydra.png")
end
function goToRuins()
    LibTools:clickOnPicture("town/toRuins.png")
end

return Rooms