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

-- отладочный метод. Перебирает все изображения с путём "tmp/<picSeriesName> (<i>).png"
-- count раз от 1 до count
function DevTools:testAction()
    -- тест
    -- print(getGameArea()) -- =	2340, 1080
    bereich = Region(1300, 600, 600, 400)
    bereich:highlight()

    -- метод
    picSeriesName="GoFree"
    count = 27

  picStart = "tmp/" .. picSeriesName .. " ("
  picEnd = ").png"

   table1 = {}
   -- tmp/GoFree (1).png
   for i = 1,count do
       table1[i] = picStart .. (i) .. picEnd
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

-- Повторяет 20 раз нажатие на одну и ту же точку экрана
function DevTools:repeatTap20()
    roomsToast("Укажите, куда нажать 20 раз")
    count = 20
    local hydraStartLoc = LibTools:getTapStartPoint()
    for i = 1,count do
        LibTools:tapWithShow(hydraStartLoc)
    end
end

function roomsToast(toastText)
    Txt:ifToast(toastText, true)
end

return DevTools