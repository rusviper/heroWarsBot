local LibTools = require('LibTools')

local Rooms = {}


adCloseLocation = Location(1940, 140)
-------------------
------TITANS-------
-------------------
function Rooms:titanCollect()
-- идём в подземелье
  if not exists("titan/titanDoor.png") then
    toast("Идём в подземелье")
    goToUnderground()
  end
-- проходим по дверям, пока не достигнем кнопки погружения
  while not exists("titan/titanDigDeep2.png") do
    titanCompleteOneDoor()
  end
  toast("Подземелье закончилось - выходим")
  Rooms:clickClose()
  exitFromGuild()
end

function titanCompleteOneDoor()
  toast("Соберём и эту дверь")
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

firstChest = "tower/tower3ChestLong.png"
smallChest = "tower/tower3ChestBig.png"
lastChest = "tower/tower6LastChestBig.png"

function isChestVisible()
   toast("Есть че по сундукам?")
   return exists(firstChest) or exists(smallChest, 0) or exists(lastChest, 0)
end

function Rooms:towerCollect()
    goToTower()

    -- идем до чемодана
    -- вместо exists использовать wait
    if not isChestVisible() then
        toast("переходим к сундукам")
        LibTools:clickIfVisible("tower/tower1Start.png")
        LibTools:clickIfVisible("tower/tower2manual.png")
    end
    -- итерируем по чемоданам
    -- чемоданы отличаются по этажам?
    if not isChestVisible() then
        toast("Чемодан не найден :(")
    else
        while isChestVisible() do
        LibTools:clickIfVisible(firstChest)
        LibTools:clickIfVisible(smallChest)
        LibTools:clickIfVisible(lastChest)
           -- LibTools:clickOnPicture(smallChest)
            LibTools:clickOnPicture("tower/tower4Open.png")
            if not exists("tower/tower5Next.png") then
                -- если нет кнопки 5, то это был последний этаж - выходим
                toast("Башня закончилась")
                break
            end
            LibTools:clickOnPicture("tower/tower5Next.png")
            wait(1)
        end
    end

    Rooms:clickClose()
    -- выходим на площадь
    Rooms:clickClose()
    Rooms:clickClose()
end

-------------------
-------AD----------
-------------------


function Rooms:adCollect()
-- идём к девке
  if isOnTown() then
    toast("Переходим к рекламным сундукам")
    LibTools:clickOnPicture("ad/ad1Girl.png")
    wait(3) -- ждем вращения сундуков
    else
    toast("Находимся не в деревне")
  end
  
  if LibTools:exists("ad/ad2Box.png") then
      adCollectOneByStartPic("ad/ad2Box.png")
  end
  LibTools:clickIfVisible("ad/ad3ToShop.png")
  if LibTools:exists("ad/ad4Shop.png") then
      adCollectOneByStartPic("ad/ad4Shop.png")
  end
 
  toast("Больше не видно рекламы")
  -- выходим в город
  wait(1)
  Rooms:clickClose()
end

-- собираем рекламу, пока видна кнопка
function adCollectOneByStartPic(adButton)
  while LibTools:exists(adButton) do
    toast("Собираем рекламку")
    LibTools:clickOnPicture(adButton)
    -- ждём окончания рекламы до 40 сек
    --wait(40)
    -- тыкаем в крестик (по координатам, т.к. он почти невидимый)
    -- todo попробовать по картинке снова, по условию
    --click(Location(2130, 175))
    if not Rooms:waitAdEnd(40) then
        toast("Не смогли закрыть рекламу")
        click(adCloseLocation)
    end
    -- ждём, пока одуплится следующая реклама
    wait(7)
  end
end
closeAdPic = "ad/ad5Close.png"
function Rooms:closeAd()
    return LibTools:clickOnPicture(closeAdPic)
end
-- найти крестик, подождать 3 сек и ткнуть в то место
function Rooms:waitAdEnd(timeout)
    rval = LibTools:clickOnPicture(closeAdPic, 1, nil, timeout)
    if rval ~= nil then return false end
    -- после первого нажатия снова появляется ещё один крестик
    -- пробуем подождать его, но ничего, если не получится
    wait(2)
    LibTools:clickIfVisible(closeAdPic, 1, nil, 3)
    return true
end


-------------------
-----HYDRA---------
-------------------

function Rooms:hydraCollect()
    -- перемещаемся к гидре
    goToHydra()
    -- идём к последним гидрам
    LibTools:clickIfVisible("hydra/hydra1Next.png")
    -- идём к кошмарной
    LibTools:clickIfVisible("hydra/hydra2h4.png")
    -- todo определять доступные головы
    hydraHead = "hydra/hydra3water.png"
    for i=1,3 do
        toast("Атакуем гидру (" .. i .."/3)")
        if exists(hydraHead) then
            LibTools:clickOnPicture(hydraHead)
            -- дальше-дальше-в бой
            LibTools:clickOnPicture("hydra/hydra4NextTeam.png")
            LibTools:clickOnPicture("hydra/hydra4NextTeam.png")
            LibTools:clickOnPicture("hydra/hydra5Fight.png")
            wait(5) -- ждем загрузки боя
            LibTools:clickOnPicture("hydra/hydra6Pause.png")
            LibTools:clickOnPicture("hydra/hydra7Skip.png")
        else
            toast("Голова гидры не найдена")
        end
    end
    -- выходим из гидры
    Rooms:clickClose()
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

--- большинство закрытий работают так, кроме башни
function Rooms:clickClose()
    closeBtn = "town/close.png"
    toast("Жмем на крестик")
    LibTools:clickIfVisible(closeBtn)
end

--- большинство закрытие для башни, но не работает в других местах
-- todo найти универсальный скриншот
function Rooms:clickCloseTower()
    closeBtn = "tower/tower7Close.png"
    toast("Жмем на крестик в башне")
    --LibTools:clickIfVisible(closeBtn)
    Rooms:clickClose()
end

function goToHydra()
    toast("Идем к гидре")
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
    toast("Идем в подземелье")
    if isOnTown() then
        goToGuild()
    end
    if isOnGuild() then
        LibTools:clickOnPicture("town/toTitans.png")
    end
end

function goToTower()
    toast("Идем в башню")
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