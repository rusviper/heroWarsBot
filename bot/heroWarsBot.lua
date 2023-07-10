package.path = scriptPath() .. 'lib/?.lua;' .. package.path
local LibTools = require('LibTools')
local Rooms = require('Rooms')
local Txt = require('Txt')
local MainTools = require('MainTools')

-- отладочный метод для определения координат нажатия
function showTouchCoords()
  print("Координаты экрана и тыка")
  print(getRealScreenSize())
  local action, locTable, touchTable = getTouchEvent()

  print(locTable)
  print(action)
  print(touchTable)

  LibTools:highlightPoint(locTable)
end


function testReadText(picName)
  btn = find(picName)
  text = btn:getTarget() .. "(" .. btn:getScore() .. ")"
  btn:highlight(text, 3)
  btnText = btn:text()
  print(btnText)
end

adAction = "Реклама"
titanAction = "Титанит"
towerAction = "Башня"
hydraAction = "Гидра"
testAction = "test"
adWaitAction = "Подождать и закрыть AD"
coordsAction = "Coords"
closeAction = "Закрыть"
outlandAction = "запределье-боссы"


function actionMenu()
    spinnerSelectedValue = ""
    dialogInit()
    spinnerItems = { adAction,
    	titanAction, towerAction, hydraAction,
        testAction, adWaitAction, coordsAction,
        closeAction, outlandAction}
    addTextView("Выберите действие: ")
    addSpinner("spinnerSelectedValue", spinnerItems, adAction)
    newRow()
    dialogShow()
    return spinnerSelectedValue
end


-- разработка с таким расширением
Settings:setScriptDimension(true, 2340)

-- экран со скрывающимися кнопками
setImmersiveMode(true)

-- стиль текста при подсветке
Txt:setTargetTextStyle()


--toast("Прочитаем текст")
--testReadText("town/townCheck.png")

action = actionMenu()
if (action == titanAction) then
    Rooms:titanCollect()
elseif (action == towerAction) then
    Rooms:towerCollect()
elseif (action == hydraAction) then
    Rooms:hydraCollect()
elseif (action == outlandAction) then
    Rooms:outlandCollect()
elseif (action == adAction) then
    Rooms:adCollect()
elseif (action == closeAction) then
    Rooms:clickClose()
elseif (action == coordsAction) then
    showTouchCoords()
elseif (action == adWaitAction) then
    Rooms:waitAdEnd(40)
elseif (action == testAction) then



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