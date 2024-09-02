local LibTools = require('LibTools')
local Txt = require('Txt')

local DevTools = {}



-- отладочный метод для определения координат нажатия
function DevTools:showTouchCoords()
  print("Координаты экрана и тыка")
  print("Screen size:" .. getRealScreenSize())

  local action, locTable, touchTable = getTouchEvent()

  print("Action:" .. action)
  print("Location table:" .. locTable)
  print("Touch table:" .. touchTable)

  LibTools:highlightPoint(locTable)
end

function DevTools:testAction()

  --DevTools:showTouchCoords()

 -- print(getGameArea()) -- =	2340, 1080
  --Region(1500, 0, 550, 1080):highlight()

  picStart = "port/port1Start"
  picEnd = ".png"
  count = 3
   table1 = {}
   table1[1] = picStart .. picEnd
   for i = 2,count do
       table1[i] = picStart .. (i-1) .. picEnd
   end
   LibTools:highlightPics(table1)

   -- ищет первое совпадение и его возвращает. проверить, работает ли. Работает!
   --found = LibTools:findFirstOf(table1)
   --if (found ~= nil) then toast("findFirstOf работает: " .. found:getScore()) end

   -- попробовать (ищет все по одному фото). используется делегат. Работает!
   LibTools:showAll(table1[1])

   -- попробовать (ищет без ошибки)
   --LibTools:findNoException("titan/titanDigDeep.png")

   -- попробовать (ищет без ошибки)
   --LibTools:findNoException("titan/titanDigDeep.png")

   -- тут findAllByColumn
   -- LibTools:findByIndex2(pic, index)
end

function DevTools:repeatTap20()
    roomsToast("Укажите, куда нажать 20 раз")
    count = 20
    local hydraStart = LibTools:getTapStartPoint()
    for i = 1,count do
        LibTools:tapWithShow(hydraStart)
    end
end

function roomsToast(toastText)
    Txt:ifToast(toastText, true)
end

return DevTools