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
------TOOLS--------
-------------------

function roomsToast(toastText)
    Txt:ifToast(toastText, true)
end