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
    if not Ad:waitAdEnd(40) then
        roomsToast("Не смогли закрыть рекламу")
        click(adCloseLocation)
    end
    -- ждём, пока одуплится следующая реклама
    wait(9)
    adBtn = LibTools:exists(adButton)
  end
end

closeAdPic = "ad/ad5Close.png"
cancelAdDownload =  "ad/ad7Cancel.png"
function Ad:closeAd()
    return LibTools:clickOnPicture(closeAdPic)
end

-- найти крестик, подождать 3 сек и ткнуть в то место
function Ad:waitAdEnd(timeout)
-- некоторые рекламы сразу показывают крестик, но если закрыть ее, то 
-- результат отрицательный. Ждем окончания, и только потом жмем закрытие. 
-- самая долгая реклама 26 сек
    wait(26)
    
    rval = LibTools:clickOnPicture(closeAdPic, timeout, nil, 1)
    if rval == nil then return false end
    -- после первого нажатия снова появляется ещё один крестик
    -- пробуем подождать его, но ничего, если не получится
    wait(2)
    -- после первого нажатия иногда всплывает окно с кнопками
    -- если оно есть, нажимаем его, но его может не быть
    rval = LibTools:clickIfVisible(cancelAdDownload, 0, nil, 1)
    -- после первого крестика снова появляется ещё один крестик
    -- пробуем подождать его, но ничего, если не получится
    LibTools:clickIfVisible(closeAdPic, 3, nil, 1)
    return true
end


-------------------
------TOOLS--------
-------------------

function roomsToast(toastText)
    Txt:ifToast(toastText, true)
end


return Ad