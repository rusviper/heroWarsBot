local LibTools = require('LibTools')
local Txt = require('Txt')

local DevTools = {}



-- отладочный метод для определения координат нажатия
function DevTools:showTouchCoords()
  print("Координаты экрана и тыка")
  print(getRealScreenSize())
  local action, locTable, touchTable = getTouchEvent()

  print(locTable)
  print(action)
  print(touchTable)

  LibTools:highlightPoint(locTable)
end

function DevTools:testAction()


 -- print(getGameArea()) -- =	2340, 1080
  --Region(1500, 0, 550, 1080):highlight()

  picStart = "hydra/hydra7Skip-"
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