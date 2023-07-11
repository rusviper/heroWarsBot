local LibTools = require('LibTools')
local Txt = require('Txt')

local Navigation = {}


--- закрытие интерфейса в игре
function Navigation:clickClose(region)
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

function Navigation:goToHydras()
    roomsToast("Идем к гидре")
    if Navigation:isOnTown() then
        Navigation:goToGuild()
    end
    if Navigation:isOnGuild() then
        Navigation:goToNestOfElements()
    end
    if Navigation:isOnNestOfElements() then
        Navigation:goToRuins() -- попадаем к гидре
    end
end

function Navigation:goToUnderground()
    roomsToast("Идем в подземелье")
    if Navigation:isOnTown() then
        Navigation:goToGuild()
        wait(2) -- ждем прогрузки гильдии, долгая
    end
    if Navigation:isOnGuild() then
        LibTools:clickOnPicture("town/toTitans.png")
    end
end

function Navigation:goToTower()
    roomsToast("Идем в башню")
    if Navigation:isOnTown() then
        LibTools:clickOnPicture("town/tower.png")
    end
end

function Navigation:exitFromGuild()
    if Navigation:isOnGuild() then
        LibTools:clickOnPicture("town/guildToTown.png")
    end
end

function Navigation:isOnTown()
    return LibTools:exists("town/toGuild.png")
end

function Navigation:goToGuild()
    LibTools:clickOnPicture("town/toGuild.png")
end

function Navigation:isOnGuild()
    return exists("town/toTitans.png")
end

function Navigation:goToNestOfElements()
    LibTools:clickOnPicture("town/toNest.png")
end

function Navigation:isOnNestOfElements()
    return exists("town/toHydra.png")
end

function Navigation:goToRuins()
    LibTools:clickOnPicture("town/toRuins.png")
end


-------------------
------TOOLS--------
-------------------

function roomsToast(toastText)
    Txt:ifToast(toastText, true)
end


return Navigation