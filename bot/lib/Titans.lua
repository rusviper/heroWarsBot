local LibTools = require('LibTools')
local Txt = require('Txt')
local Navigation = require('Navigation')

local Titans = {}




-------------------
------TITANS-------
-------------------
function Titans:titanCollect()
-- идём в подземелье
  if not isTitanDoorVisible() then
    roomsToast("Идём в подземелье")
    Navigation:goToUnderground()
  end
-- проходим по дверям, пока не достигнем кнопки погружения
  while not isStageCompleted() do
    titanCompleteOneDoor()
  end
  roomsToast("Подземелье закончилось - выходим")
  Navigation:clickClose()
  Navigation:exitFromGuild()
end

function isTitanDoorVisible()
    return exists("titan/titanDoor.png")
end

function isStageCompleted()
    return exists("titan/titanDigDeep.png")
end

function titanCompleteOneDoor()
  -- жмём на дверь "в бой"
  foundDoor = LibTools:clickOnPicture("titan/titanDoor.png")
  if (foundDoor == nil) then
    roomsToast("Дверь не найдена")
    return
  end

  roomsToast("Соберём и эту дверь")
  -- жмём на кнопку "напасть"
  LibTools:clickOnPicture("titan/titanAttack.png")
  -- жмём на кнопку "автобой"
  LibTools:clickOnPicture("titan/titanAutoFight.png")
  -- жмём на кнопку "OK"
  LibTools:clickOnPicture("titan/titanOK.png")
end

-- бои во время событий
function Titans:eventFights()
  -- цикл по боям 
  local count = 20
  for i=1,count do
    roomsToast("Цикл " .. i .. " из " .. count)
    eventFight()
   end
  
end


function eventFight()
  -- жмём в атаку
  attackPic="event/event1attack.png"
  --LibTools:clickOnPicture(attackPic)
  --LibTools:clickOnPicture("titan/titanAttack.png")
  
  btnAttack = Region(1860, 915, 6, 6)
  click(btnAttack)
  -- выбираем титанов и в бой
  --LibTools:clickOnPicture("titan/titanOk.png")
  LibTools:clickOnPicture("hydra/hydra4NextTeam3.png")
  -- ждем паузу
  LibTools:clickOnPicture("hydra/hydra6Pause.png", 15)    -- ждём подольше, т.к. бой долго прогружается иногда
  -- пропустить
  LibTools:clickOnPicture("hydra/hydra7Skip.png")
  -- ок
  LibTools:clickOnPicture("event/event2End.png")
  
  wait(1)
end




-------------------
------TOOLS--------
-------------------

function roomsToast(toastText)
    Txt:ifToast(toastText, true)
end

return Titans