local LibTools = require('LibTools')
local Txt = require('Txt')
local Navigation = require('Navigation')

local Ad = {}

adCloseLocation = Location(1940, 140)


-------------------
-------AD----------
-------------------


function Ad:adCollect()
-- идём к девке
  if Navigation:isOnTown() then
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
  Navigation:clickClose()
end

-- собираем рекламу, пока видна кнопка
function adCollectOneByStartPic(adButton)
  adBtn = LibTools:exists(adButton)
  while adBtn ~= nil do
    roomsToast("Собираем рекламку")
    click(adBtn)
    -- ждём окончания рекламы до 40 сек
    if not Da:waitAdEnd(40) then
        roomsToast("Не смогли закрыть рекламу")
        click(adCloseLocation)
    end
    -- ждём, пока одуплится следующая реклама
    wait(9)
    adBtn = LibTools:exists(adButton)
  end
end

closeAdPic = "ad/ad5Close.png"
function Ad:closeAd()
    return LibTools:clickOnPicture(closeAdPic)
end

-- найти крестик, подождать 3 сек и ткнуть в то место
function Ad:waitAdEnd(timeout)
    rval = LibTools:clickOnPicture(closeAdPic, 1, nil, timeout)
    if rval == nil then return false end
    -- после первого нажатия снова появляется ещё один крестик
    -- пробуем подождать его, но ничего, если не получится
    wait(2)
    LibTools:clickIfVisible(closeAdPic, 1, nil, 3)
    return true
end


-------------------
------TOOLS--------
-------------------

function roomsToast(toastText)
    Txt:ifToast(toastText, true)
end


return Ad