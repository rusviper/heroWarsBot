local LibTools = require('LibTools')
local Txt = require('Txt')
local Navigation = require('Navigation')

local Port = {}


-------------------
-----Port---------
-------------------


function Port:collect()
   for i = 1,10 do
       roomsToast("Порт (" .. i .."/10)")
       -- заменить на while
       rval = Port:collectOne()
       if not rval then
         roomsToast("Не найдена кнопка, заканчиваем")
         return
       end
   end
end

-- Один заход в порт
function Port:collectOne()
  -- Нажимаем начало
  btn1 = portStart()
  if btn1 == nil then
        return false
  end
  
  -- Выбираем кого атаковать
  btn = selectShip()
  if btn == nil then
        return false
  end
  
  -- нажимаем атаку
  startFight()
  
  -- пропускаем бой
  skipFight()
  return true
end


-- нажимаем "в бой!"
function startFight()
    LibTools:clickOnPicture("hydra/hydra4NextTeam.png")
    --LibTools:clickOnPicture("port/port3Fight.png")
end

-- нажимаем "пауза", "пропустить"
function skipFight()
    -- атака уже начинается (нажали "в бой" или "следующий бой")
    LibTools:clickOnPicture("hydra/hydra6Pause.png", 15)    -- ждём подольше, т.к. бой долго прогружается иногда
    LibTools:clickOnPicture("hydra/hydra7Skip.png")
end

function selectShip()
    fightPic = "hydra/hydra4NextTeam.png"
    rightRegion = Region(1500, 0, 550, 1080)
    
    forwardBtn =  LibTools:findPicOnRegion(rightRegion, fightPic)
    if forwardBtn == nil then
        roomsToast("Не найдена кнопка, пропускаем")
        return nil
    else
        click(forwardBtn)
    end
    return forwardBtn
  --LibTools:clickOnPicture("hydra/hydra4NextTeam.png")
  --  LibTools:clickOnPicture("port/port2Ship.png")
end

function portStart()
    return LibTools:clickOnPicture("port/port1Start.png")
end



-------------------
------TOOLS--------
-------------------

function roomsToast(toastText)
    Txt:ifToast(toastText, true)
end



return Port