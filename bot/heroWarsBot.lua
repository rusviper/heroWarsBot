package.path = scriptPath() .. 'lib/?.lua;' .. package.path
local LibTools = require('LibTools')
local Rooms = require('Rooms')

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
testAction = "test"
closeAction = "Закрыть"
coordsAction = "Coords"
adWaitAction = "Подождать и закрыть AD"
hydraAction = "Гидра"

function actionMenu()
    spinnerSelectedValue = ""
    dialogInit()
    spinnerItems = { adAction, titanAction, towerAction,
        testAction, closeAction, coordsAction,
        adWaitAction, hydraAction }
    addTextView("Выберите действие: ")
    addSpinner("spinnerSelectedValue", spinnerItems, adAction)
    newRow()
    dialogShow()
    return spinnerSelectedValue
end

function tSize(t)
    size = 0
    for a,b in pairs(t) do
        print("" .. a .. "-" .. b)
        size = size + 1
    end
    return size
end

-- разработка с таким расширением
--Settings:setScriptDimension(true, 2340)

-- экран со скрывающимися кнопками
setImmersiveMode(true)

-- стиль текста при подсветке
setHighlightTextStyle(0xa5555555, 0xf8eeeeee, 8)


--toast("Прочитаем текст")
--testReadText("town/townCheck.png")


action = actionMenu()
if (action == titanAction) then
    Rooms:titanCollect()
elseif (action == towerAction) then
    Rooms:towerCollect()
elseif (action == hydraAction) then
    Rooms:hydraCollect()
elseif (action == adAction) then
    Rooms:adCollect()
elseif (action == closeAction) then
    Rooms:clickClose()
elseif (action == coordsAction) then
    showTouchCoords()
elseif (action == adWaitAction) then
    Rooms:waitAdEnd(40)
elseif (action == testAction) then

  picStart = "titan/titanDigDeep"
  picEnd = ".png"

   table1 = {}
   table1[1] = picStart .. picEnd
   for i = 2,4 do
       table1[i] = picStart .. (i-1) .. picEnd
   end
   --LibTools:highlightPics(table1)
   table1["q1"] = 123

   toast("table=" .. table1["q1"])
   toast("getn=" .. table.getn(table1))
   toast("tSize=" .. tSize(table1))
   --LibTools:showAll("titan/titanDigDeep.png")
   --LibTools:findNoException("titan/titanDigDeep.png")
end