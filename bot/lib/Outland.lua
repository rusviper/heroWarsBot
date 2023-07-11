local LibTools = require('LibTools')
local Txt = require('Txt')
local Navigation = require('Navigation')

local Outland = {}

--------------------
-----OUTLAND--------
--------------------

--Region(300, 0, 850, 1080) --левая половина

bossesRegion = Region(1150, 0, 850, 1080)
boss1Region = Region(300, 0, 550, 1080)
boss2Region = Region(900, 0, 550, 1080)
boss3Region = Region(1500, 0, 550, 1080)

function Outland:outlandCollect()

    collectBoss(1)
    collectBoss(2)
    collectBoss(3)
    collectBoss(3)
    collectBoss(3)
end

function collectBoss(bossIndex)
    bossRegion = boss3Region
    if bossIndex == 1 then
      bossRegion = boss1Region
    elseif bossIndex == 2 then
        bossRegion = boss2Region
    elseif bossIndex == 3 then
        bossRegion = boss3Region
    else
        roomsToast("Неправильный индекс босса " .. bossIndex)
        return
    end

    selectBossPic = "outland/outland1SelectBoss.png"
    selectBtn = LibTools:findPicOnRegion(bossRegion, selectBossPic)
    if selectBtn == nil then
        roomsToast("Не найдена кнопка, должны находиться на выборе босса")
        return
    end
    click(selectBtn)

    -- для каждого босса скорее всго будет разный скриншот
    -- лучше сначала найти кнопку рейд? она более уникальна вроде как
    -- иначе "дальше" находится на кнопке "в бой"
    forwardPic = "outland/outland2GoForward.png"
    forwardRegion = Region(1250, 500, 1000, 500)
    forwardBtn =  LibTools:findPicOnRegion(forwardRegion, forwardPic)
    if forwardBtn == nil then
        roomsToast("Не найдена кнопка (дальше>), пропускаем")
    else
        click(forwardBtn)
    end


    LibTools:clickOnPicture("outland/outland3Raid.png")
    wait(2)
    LibTools:clickOnPicture("outland/outland4Free.png")

    Navigation:clickClose()
    Navigation:clickClose()
    Navigation:clickClose()

end

function oneChestBoss(bossPic)
    -- должны находиться на выборе одного из 3 боссов
    LibTools:clickPicOnPic(bossPic, "outland/outland6Select.png")
    LibTools:clickOnPicture("outland/outland5Forward.png")
    wait(1)
    LibTools:clickOnPicture("outland/outland6Select.png") -- рейд
    LibTools:clickOnPicture("outland/outland7Free.png") -- бесплатно
    wait(3)
    Navigation:clickClose() -- выход
    Navigation:clickClose() -- ещё выход
    Navigation:clickClose() -- оказываемся у боссов
end




-------------------
------TOOLS--------
-------------------

function roomsToast(toastText)
    Txt:ifToast(toastText, true)
end